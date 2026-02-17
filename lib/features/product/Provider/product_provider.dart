import 'dart:math';

import 'package:appshop/core/models/product_image_model.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/features/product/Repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final String _userId;
  final String _token;

  late final ProductRepository _repository;

  List<ProductModel> _produtos = [];

  ProductProvider([
    this._token = '',
    this._userId = '',
    this._produtos = const [],
  ]) {
    _repository = ProductRepository(token: _token, userId: _userId);
  }

  List<ProductModel> get produtos => [..._produtos];
  List<ProductModel> get produtosFavoritos =>
      _produtos.where((prod) => prod.isFavorite).toList();

  List<ProductModel> get meusProdutos =>
      _produtos.where((p) => p.userId == _userId).toList();

  List<ProductModel> get produtosParaCompra =>
      _produtos.where((p) => p.userId != _userId).toList();

  List<ProductModel> get meusFavoritos => _produtos
      .where((p) => p.isFavorite == true && p.userId != _userId)
      .toList();

  int get quantidadeDeProdutos {
    return _produtos.length;
  }

  Future<void> carregarProdutos() async {
    final produtos = await _repository.carregarProdutos();

    _produtos = produtos;
    notifyListeners();
  }

  List<ProductModel> searchByName(String query) {
    final q = query.toLowerCase();

    return _produtos.where((p) {
      return p.name.toLowerCase().contains(q);
    }).toList();
  }

  List<ProductModel> produtosPorCategoria(String categoryId) {
    final lista = _produtos.where((p) {
      return p.categories.contains(categoryId);
    }).toList();

    return lista.where((p) => p.userId != _userId).toList();
  }

  Future<void> salvarProduto(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final newProduct = new ProductModel(
      id: hasId ? data["id"].toString() : Random().nextDouble().toString(),
      name: data["name"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      imageUrls: data["imageUrls"] as List<ProductImageModel>,
      categories: List<String>.from(data['categories'] as List<String>),
      userId: _userId,
    );

    if (hasId) {
      return atualizarProduto(newProduct);
    } else {
      return adicionarProduto(newProduct);
    }
  }

  Future<void> adicionarProduto(ProductModel produto) async {
    final generateId = await _repository.adicionarProduto(produto);

    final newProduct = produto.copyWith(id: generateId);

    _produtos.add(newProduct);
    notifyListeners();
  }

  Future<void> atualizarProduto(ProductModel produto) async {
    int index = _produtos.indexWhere((p) => p.id == produto.id);

    if (index < 0) return;

    await _repository.atualizarProduto(produto);

    _produtos[index] = produto;
    notifyListeners();
  }

  Future<void> deletarProduto(ProductModel produto) async {
    int index = _produtos.indexWhere((p) => p.id == produto.id);

    if (index < 0) return;

    try {
      await _repository.deletarProduto(produto.id);

      _produtos.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint("Não foi possivel remover o item $index: $e");
      rethrow;
    }
  }

  Future<void> adicionarOuRemoverFavorito(String productId) async {
    final index = _produtos.indexWhere((p) => p.id == productId);

    if (index < 0) return;

    final product = _produtos[index];

    product.isFavorite = !product.isFavorite;
    notifyListeners();

    try {
      await _repository.adicionarOuRemoverFavorito(
          productId: productId, isFavorite: product.isFavorite);
    } catch (e) {
      // rollback
      product.isFavorite = !product.isFavorite;
      debugPrint("Erro ao desfavoritar/favoritar produto: $e");
      rethrow;
    }
  }
}

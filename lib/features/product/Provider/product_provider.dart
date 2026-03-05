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

  void setProdutos(List<ProductModel> value) {
    _produtos = value;
    notifyListeners();
  }

  Future<void> carregarProdutos() async {
    final produtos = await _repository.carregarProdutos();
    final favoritos = await _repository.carregarFavoritos();

    final List<ProductModel> atualizados = [];

    for (var product in produtos) {
      if (product.isPromotional &&
          product.promotionEndDate != null &&
          product.promotionEndDate!.isBefore(DateTime.now())) {
        final novoProduto = product.copyWith(
          isPromotional: false,
          discountPercentage: () => null,
          promotionEndDate: () => null,
        );

        await _repository.atualizarProduto(novoProduto);
        atualizados.add(novoProduto);
      } else {
        atualizados.add(product);
      }
    }

    final produtosAtualizados = atualizados.map((produto) {
      return produto.copyWith(
        isFavorite: favoritos.contains(produto.id),
      );
    }).toList();

    setProdutos(produtosAtualizados);
  }

  List<ProductModel> searchByName(String query) {
    final q = query.toLowerCase();

    final lista = _produtos.where((p) {
      return p.name.toLowerCase().contains(q);
    }).toList();

    return lista.where((p) => p.userId != _userId).toList();
  }

  List<ProductModel> produtosPorCategoria(String categoryId) {
    final lista = _produtos.where((p) {
      return p.categories.contains(categoryId);
    }).toList();

    return lista.where((p) => p.userId != _userId).toList();
  }

  Future<void> salvarProduto(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final isPromotional = data["isPromotional"] == true ||
        data["discountPercentage"] != null ||
        data["promotionEndDate"] != null ||
        data["promotionValidUntil"] != null;

    final promotionDateRaw =
        data["promotionEndDate"] ?? data["promotionValidUntil"];
    final DateTime? promotionEndDate = promotionDateRaw != null
        ? DateTime.parse(promotionDateRaw as String)
        : null;

    final newProduct = ProductModel(
      id: hasId ? data["id"].toString() : Random().nextDouble().toString(),
      name: data["name"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      imageUrls: data["imageUrls"] as List<ProductImageModel>,
      categories: List<String>.from(data['categories'] as List<String>),
      userId: _userId,
      isPromotional: isPromotional,
      discountPercentage: data["discountPercentage"] as int?,
      promotionEndDate: promotionEndDate,
    );

    if (hasId) {
      return atualizarProduto(newProduct);
    } else {
      return adicionarProduto(newProduct);
    }
  }

  Future<void> adicionarProduto(ProductModel produto) async {
    final generateId = await _repository.adicionarProduto(produto);

    final novoProduto = produto.copyWith(id: generateId);

    setProdutos([..._produtos, novoProduto]);
  }

  Future<void> atualizarProduto(ProductModel produto) async {
    await _repository.atualizarProduto(produto);

    final lista =
        _produtos.map((e) => e.id == produto.id ? produto : e).toList();

    setProdutos(lista);
  }

  Future<void> deletarProduto(ProductModel produto) async {
    await _repository.deletarProduto(produto.id);

    final lista = _produtos.where((p) => p.id != produto.id).toList();

    setProdutos(lista);
  }

  Future<void> adicionarOuRemoverFavorito(String productId) async {
    final index = _produtos.indexWhere((p) => p.id == productId);

    if (index < 0) return;

    final product = _produtos[index];

    product.isFavorite = !product.isFavorite;
    notifyListeners();

    await _repository.adicionarOuRemoverFavorito(
        productId: productId, isFavorite: product.isFavorite);
  }
}

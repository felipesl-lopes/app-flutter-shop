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

  int get itemsCount {
    return _produtos.length;
  }

  Future<void> loadProducts() async {
    final produtos = await _repository.loadProducts();

    _produtos = produtos;
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final newProduct = new ProductModel(
      id: hasId ? data["id"].toString() : Random().nextDouble().toString(),
      name: data["name"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      imageUrls: data["imageUrls"] as List<ProductImageModel>,
      userId: _userId,
    );

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
  }

  Future<void> addProduct(ProductModel produto) async {
    final generateId = await _repository.addProduct(produto);

    final newProduct = produto.copyWith(id: generateId);

    _produtos.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel produto) async {
    int index = _produtos.indexWhere((p) => p.id == produto.id);

    if (index < 0) return;

    await _repository.updateProduct(produto);

    _produtos[index] = produto;
    notifyListeners();
  }

  Future<void> deleteProduct(ProductModel produto) async {
    int index = _produtos.indexWhere((p) => p.id == produto.id);

    if (index < 0) return;

    try {
      await _repository.deleteProduct(produto.id);

      _produtos.removeAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint("Não foi possivel remover o item $index: $e");
      rethrow;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final index = _produtos.indexWhere((p) => p.id == productId);

    if (index < 0) return;

    final product = _produtos[index];

    product.isFavorite = !product.isFavorite;
    notifyListeners();

    try {
      await _repository.toggleFavorite(
          productId: productId, isFavorite: product.isFavorite);
    } catch (e) {
      // rollback
      product.isFavorite = !product.isFavorite;
      debugPrint("Erro ao desfavoritar/favoritar produto: $e");
      rethrow;
    }
  }
}

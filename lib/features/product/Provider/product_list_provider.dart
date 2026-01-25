import 'dart:convert';
import 'dart:math';

import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/models/product_image_model.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductListProvider with ChangeNotifier {
  List<ProductModel> _items = [];
  final String _userId;
  final String _token;

  List<ProductModel> get items => [..._items];
  List<ProductModel> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductListProvider([
    this._token = "",
    this._userId = "",
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    // obter produtos
    final response = await http
        .get(Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$_token"));

    if (response.body == "null") {
      return;
    }

    // obter favoritos
    final favResponse = await http.get(
      Uri.parse("${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token"),
    );

    Map<String, dynamic> favData =
        favResponse.body == "null" ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    _items.clear();
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      final List imageData = (productData['imageUrls'] ?? []) as List;

      _items.add(
        ProductModel(
          id: productId,
          name: productData["name"],
          description: productData["description"],
          price: productData["price"],
          imageUrls:
              imageData.map((e) => ProductImageModel.fromMap(e)).toList(),
          isFavorite: isFavorite,
          userId: productData["userId"],
        ),
      );
    });
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

  Future<void> addProduct(ProductModel product) async {
    final response = await http.post(
        Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$_token"),
        body: jsonEncode({
          "userId": _userId,
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrls": product.imageUrls,
        }));

    final _data = jsonDecode(response.body);
    _items.add(
      ProductModel(
        userId: _userId,
        id: _data["name"],
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrls: product.imageUrls,
        isFavorite: product.isFavorite,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
          Uri.parse(
              "${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token"),
          body: jsonEncode({
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrls": product.imageUrls,
            "userId": _userId,
          }));

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];

      if (product.userId != _userId) {
        throw GenericExeption.ExceptionMsg(
            msg: "Você não tem permissão para excluir o produto",
            statusCode: 403);
      }

      final response = await http.delete(
        Uri.parse(
            "${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token"),
      );

      if (response.statusCode >= 400) {
        throw GenericExeption.ExceptionMsg(
          msg: "Não foi possivel excluir o produto.",
          statusCode: response.statusCode,
        );
      }

      _items.remove(product);
      notifyListeners();
    }
  }
}

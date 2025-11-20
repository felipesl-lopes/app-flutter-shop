import 'dart:convert';
import 'dart:math';

import 'package:appshop/exceptions/http_exception.dart';
import 'package:appshop/models/product.dart';
import 'package:appshop/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  final String _userId;
  final String _token;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([
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
      _items.add(
        Product(
          id: productId,
          name: productData["name"],
          description: productData["description"],
          price: productData["price"],
          imageUrl: productData["imageUrl"],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final newProduct = new Product(
      id: hasId ? data["id"].toString() : Random().nextDouble().toString(),
      name: data["name"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      imageUrl: data["imageUrl"] as String,
    );

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
        Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$_token"),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }));

    final _data = jsonDecode(response.body);
    _items.add(
      Product(
        id: _data["name"],
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
          Uri.parse(
              "${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token"),
          body: jsonEncode({
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            "${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token"),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExceptionMsg(
          msg: "Não foi possivel excluir o produto.",
          statusCode: response.statusCode,
        );
      }
    }
  }
}

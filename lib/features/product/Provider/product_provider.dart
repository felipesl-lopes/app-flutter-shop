import 'dart:convert';

import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/models/product_image_model.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final ProductModel _product;

  ProductProvider(this._product);

  String get id => _product.id;
  String get name => _product.name;
  List<ProductImageModel> get imageUrls => _product.imageUrls;
  bool get isFavorite => _product.isFavorite;
  ProductModel get product => _product;
  double get price => _product.price;
  String get description => _product.description;

  void _toggleFavorite() {
    _product.isFavorite = !_product.isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId, String email) async {
    _toggleFavorite();

    final url =
        "${Constants.USER_FAVORITES_URL}/$userId/${_product.id}.json?auth=$token";

    http.Response response;

    if (_product.isFavorite) {
      response = await http.put(Uri.parse(url), body: jsonEncode(true));
    } else {
      response = await http.delete(Uri.parse(url));
    }

    if (response.statusCode >= 400) {
      _toggleFavorite();
      if (_product.isFavorite) {
        response = await http.put(Uri.parse(url), body: jsonEncode(true));
      } else {
        response = await http.delete(Uri.parse(url));
      }

      throw GenericExeption.ExceptionMsg(
        msg: _product.isFavorite
            ? "Não foi possível desfavoritar o produto."
            : "Não foi possível favoritar o produto.",
        statusCode: response.statusCode,
      );
    }
  }
}

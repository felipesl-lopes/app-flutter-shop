import 'dart:convert';

import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String userId;
  bool isFavorite;

  ProductProvider({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.userId,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId, String email) async {
    _toggleFavorite();

    final url =
        "${Constants.USER_FAVORITES_URL}/$userId/${id}.json?auth=$token";

    http.Response response;

    if (isFavorite) {
      response = await http.put(Uri.parse(url), body: jsonEncode(true));
    } else {
      response = await http.delete(Uri.parse(url));
    }

    if (response.statusCode >= 400) {
      _toggleFavorite();
      if (isFavorite) {
        response = await http.put(Uri.parse(url), body: jsonEncode(true));
      } else {
        response = await http.delete(Uri.parse(url));
      }

      throw GenericExeption.ExceptionMsg(
        msg: isFavorite
            ? "Não foi possível desfavoritar o produto."
            : "Não foi possível favoritar o produto.",
        statusCode: response.statusCode,
      );
    }
  }
}

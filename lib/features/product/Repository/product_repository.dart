import 'dart:convert';

import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/models/product_image_model.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  /////////

  final String token;
  final String userId;

  ProductRepository({
    required this.token,
    required this.userId,
  });

  Future<List<ProductModel>> loadProducts() async {
    final response = await http
        .get(Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$token"));

    if (response.body == "null") {
      return [];
    }

    final favResponse = await http.get(
      Uri.parse("${Constants.USER_FAVORITES_URL}/$userId.json?auth=$token"),
    );

    Map<String, dynamic> favData =
        favResponse.body == "null" ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    final List<ProductModel> produtos = [];

    data.forEach(
      (productId, productData) {
        final isFavorite = favData[productId] ?? false;
        final List imageData = (productData['imageUrls'] ?? []) as List;

        produtos.add(
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
      },
    );
    return produtos;
  }

  Future<String> addProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$token"),
      body: jsonEncode({
        "userId": userId,
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrls": product.imageUrls,
      }),
    );
    final data = jsonDecode(response.body);

    return data['name'];
  }

  Future<void> updateProduct(ProductModel product) async {
    await http.patch(
      Uri.parse("${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$token"),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrls": product.imageUrls,
        "userId": userId,
      }),
    );
  }

  Future<void> deleteProduct(String idProduto) async {
    final response = await http.delete(
      Uri.parse("${Constants.PRODUCT_BASE_URL}/${idProduto}.json?auth=$token"),
    );

    if (response.statusCode >= 400) {
      throw GenericExeption.ExceptionMsg(
        msg: "Não foi possivel excluir o produto.",
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> toggleFavorite({
    required String productId,
    required bool isFavorite,
  }) async {
    final url =
        "${Constants.USER_FAVORITES_URL}/$userId/${productId}.json?auth=$token";

    http.Response response;

    if (isFavorite) {
      response = await http.put(Uri.parse(url), body: jsonEncode(true));
    } else {
      response = await http.delete(Uri.parse(url));
    }

    if (response.statusCode >= 400) {
      throw GenericExeption.ExceptionMsg(
        msg: isFavorite
            ? "Não foi possível desfavoritar o produto."
            : "Não foi possível favoritar o produto.",
        statusCode: response.statusCode,
      );
    }
  }
}

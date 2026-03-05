import 'dart:convert';

import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/models/product_image_model.dart';
import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final String token;
  final String userId;

  ProductRepository({
    required this.token,
    required this.userId,
  });

  Future<List<ProductModel>> carregarProdutos() async {
    final response = await http
        .get(Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$token"));

    if (response.body == "null") {
      return [];
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    final List<ProductModel> produtos = [];

    data.forEach(
      (productId, productData) {
        final List imageData = (productData['imageUrls'] ?? []) as List;
        final promotionDateRaw = productData['promotionEndDate'] ??
            productData['promotionValidUntil'];

        produtos.add(
          ProductModel(
            id: productId,
            name: productData["name"],
            description: productData["description"],
            price: productData["price"],
            imageUrls:
                imageData.map((e) => ProductImageModel.fromMap(e)).toList(),
            categories: productData['categories'] == null
                ? []
                : List<String>.from(productData['categories']),
            userId: productData["userId"],
            isPromotional: productData['isPromotional'] ?? false,
            discountPercentage: productData['discountPercentage'] != null
                ? (productData['discountPercentage'] as num).toInt()
                : null,
            promotionEndDate: promotionDateRaw != null
                ? DateTime.parse(promotionDateRaw as String)
                : null,
          ),
        );
      },
    );
    return produtos;
  }

  Future<Set<String>> carregarFavoritos() async {
    final response = await http.get(
      Uri.parse("${Constants.USER_FAVORITES_URL}/$userId.json?auth=$token"),
    );

    if (response.body == 'null') return {};

    final Map<String, dynamic> data = jsonDecode(response.body);

    return data.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toSet();
  }

  Future<String> adicionarProduto(ProductModel product) async {
    final response = await http.post(
      Uri.parse("${Constants.PRODUCT_BASE_URL}.json?auth=$token"),
      body: jsonEncode({
        "userId": userId,
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrls": product.imageUrls,
        "categories": product.categories,
        "isPromotional": product.isPromotional,
        "discountPercentage": product.discountPercentage,
        "promotionEndDate": product.promotionEndDate?.toIso8601String(),
      }),
    );
    final data = jsonDecode(response.body);

    return data['name'];
  }

  Future<void> atualizarProduto(ProductModel product) async {
    await http.patch(
      Uri.parse("${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$token"),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrls": product.imageUrls,
        "userId": userId,
        "categories": product.categories,
        "isPromotional": product.isPromotional,
        "discountPercentage": product.discountPercentage,
        "promotionEndDate": product.promotionEndDate?.toIso8601String(),
      }),
    );
  }

  Future<void> deletarProduto(String idProduto) async {
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

  Future<void> adicionarOuRemoverFavorito({
    required String productId,
    required bool isFavorite,
  }) async {
    final url =
        "${Constants.USER_FAVORITES_URL}/$userId/${productId}.json?auth=$token";

    // ignore: unused_local_variable
    http.Response response;

    if (isFavorite) {
      response = await http.put(Uri.parse(url), body: jsonEncode(true));
    } else {
      response = await http.delete(Uri.parse(url));
    }
  }
}

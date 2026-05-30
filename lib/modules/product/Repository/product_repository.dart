import 'package:appshop/shared/Models/product_image_model.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/core/errors/generic_exception.dart';
import 'package:appshop/shared/services/i_http_client.dart';
import 'package:flutter/material.dart';

class ProductRepository {
  final IHttpClient client;

  ProductRepository(this.client);

  Future<List<ProductModel>> carregarProdutos() async {
    debugPrint('[ProductRepository]: carregarProdutos:');

    try {
      final response = await client.get("products");

      if (response.data == "null") {
        return [];
      }

      final data = response.data;
      final List<ProductModel> produtos = [];
      if (data == null) return [];

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
              quantity:
                  productData['quantity'] == null ? 1 : productData['quantity'],
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
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Erro ao carregar produtos.");
    }
  }

  Future<List<String>> carregarFavoritos({
    required String userId,
  }) async {
    debugPrint('[ProductRepository]: carregarFavoritos:');

    try {
      final response = await client.get("userFavorites/$userId");
      if (response.data == null) return [];
      final data = response.data as Map<String, dynamic>;
      final List<String> favoritos = [];

      data.forEach((productId, isFavorite) {
        if (isFavorite == true) {
          favoritos.add(productId);
        }
      });

      return favoritos;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao carregar favoritos.');
    }
  }

  Future<String> adicionarProduto(
    ProductModel product, {
    required String userId,
  }) async {
    debugPrint('[ProductRepository]: adicionarProduto:');

    try {
      final body = {
        "userId": userId,
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "quantity": product.quantity,
        "imageUrls": product.imageUrls.map((e) => e.toMap()).toList(),
        "categories": product.categories,
        "isPromotional": product.isPromotional,
        "discountPercentage": product.discountPercentage,
        "promotionEndDate": product.promotionEndDate?.toIso8601String(),
      };

      final response = await client.post('products', body: body);
      final data = response.data;

      return data['name'];
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar produto.');
    }
  }

  Future<void> atualizarProduto(
    ProductModel product, {
    required String userId,
  }) async {
    debugPrint('[ProductRepository]: atualizarProduto:');

    try {
      final body = {
        "userId": userId,
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "quantity": product.quantity,
        "imageUrls": product.imageUrls.map((e) => e.toMap()).toList(),
        "categories": product.categories,
        "isPromotional": product.isPromotional,
        "discountPercentage": product.discountPercentage,
        "promotionEndDate": product.promotionEndDate?.toIso8601String(),
      };

      await client.patch('products/${product.id}', body: body);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao atualizar produto.');
    }
  }

  Future<void> deletarProduto(String idProduto) async {
    debugPrint('[ProductRepository]: deletarProduto:');

    try {
      final response = await client.delete('products/$idProduto');

      if (response.statusCode >= 400) {
        throw GenericExeption.ExceptionMsg(
          msg: "Não foi possivel excluir o produto.",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao deletar produto.');
    }
  }

  Future<void> adicionarOuRemoverFavorito({
    required String productId,
    required bool isFavorite,
    required String userId,
  }) async {
    debugPrint('[ProductRepository]: adicionarOuRemoverFavorito:');

    try {
      final path = 'userFavorites/$userId/$productId';

      if (isFavorite) {
        await client.put(path, body: true);
      } else {
        await client.delete(path);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar/remover favorito');
    }
  }
}

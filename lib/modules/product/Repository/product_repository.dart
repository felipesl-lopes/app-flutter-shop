import 'package:appshop/shared/Models/product_image_model.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/core/errors/generic_exception.dart';
import 'package:appshop/shared/services/i_http_client.dart';

class ProductRepository {
  final IHttpClient client;

  ProductRepository(this.client);

  Future<List<ProductModel>> carregarProdutos() async {
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

  Future<List<String>> carregarFavoritos({
    required String userId,
  }) async {
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
  }

  Future<String> adicionarProduto(
    ProductModel product, {
    required String userId,
  }) async {
    final body = {
      "userId": userId,
      "name": product.name,
      "description": product.description,
      "price": product.price,
      "imageUrls": product.imageUrls.map((e) => e.toJson()).toList(),
      "categories": product.categories,
      "isPromotional": product.isPromotional,
      "discountPercentage": product.discountPercentage,
      "promotionEndDate": product.promotionEndDate?.toIso8601String(),
    };

    final response = await client.post('products', body: body);

    final data = response.data;

    return data['name'];
  }

  Future<void> atualizarProduto(
    ProductModel product, {
    required String userId,
  }) async {
    final body = {
      "userId": userId,
      "name": product.name,
      "description": product.description,
      "price": product.price,
      "imageUrls": product.imageUrls.map((e) => e.toJson()).toList(),
      "categories": product.categories,
      "isPromotional": product.isPromotional,
      "discountPercentage": product.discountPercentage,
      "promotionEndDate": product.promotionEndDate?.toIso8601String(),
    };

    await client.patch('products/${product.id}', body: body);
  }

  Future<void> deletarProduto(String idProduto) async {
    final response = await client.delete('products/$idProduto');

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
    required String userId,
  }) async {
    final path = 'userFavorites/$userId/$productId';

    if (isFavorite) {
      await client.put(path, body: true);
    } else {
      await client.delete(path);
    }
  }
}

import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductRepository {
  final IHttpClient _client;

  ProductRepository(this._client);

  Future<List<ProductModel>> carregarProdutos() async {
    debugPrint('[ProductRepository]: carregarProdutos');

    try {
      final response = await _client.get('products');

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final produtos = (response.data as List)
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return produtos;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Erro ao carregar produtos.");
    }
  }

  Future<List<ProductModel>> carregarMeusProdutos() async {
    debugPrint('[ProductRepository]: carregarMeusProdutos');

    try {
      final response = await _client.get('products/my');

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final produtos = (response.data as List)
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return produtos;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Erro ao carregar produtos.");
    }
  }

  Future<ProductModel?> buscarProdutoPorId(String productId) async {
    debugPrint('[ProductRepository]: buscarProdutoPorId:');

    try {
      final response = await _client.get('products/$productId');

      if (response.statusCode != 200) {
        throw Exception('Erro na requisição');
      }

      final data = response.data;

      return ProductModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<String>> carregarFavoritos() async {
    debugPrint('[ProductRepository]: carregarFavoritos:');

    try {
      final response = await _client.get('userFavorites');

      if (response.statusCode != 200) {
        return [];
      }

      final List<dynamic> data = response.data;

      return data.map((e) => e.toString()).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao carregar favoritos.');
    }
  }

  Future<String> adicionarProduto(ProductModel product) async {
    debugPrint('[ProductRepository]: adicionarProduto:');

    try {
      final response = await _client.post(
        'products',
        body: product.toMap(),
      );

      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar produto.');
    }
  }

  Future<ProductModel> atualizarProduto(ProductModel product) async {
    debugPrint('[ProductRepository]: atualizarProduto:');

    try {
      final response = await _client.patch(
        'products/${product.id}',
        body: product.toUpdateMap(),
      );

      if (response.statusCode > 400) {
        return throw Exception('Erro ao atualizar produto.');
      }

      final produto = ProductModel.fromMap(response.data);

      return produto;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao atualizar produto.');
    }
  }

  Future<void> deletarProduto(String idProduto) async {
    debugPrint('[ProductRepository]: deletarProduto:');

    try {
      final response = await _client.delete('products/$idProduto');

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
  }) async {
    debugPrint('[ProductRepository]: adicionarOuRemoverFavorito');

    try {
      if (isFavorite) {
        await _client.put(
          'userFavorites/$productId',
          body: {},
        );
      } else {
        await _client.delete('userFavorites/$productId');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar/remover favorito');
    }
  }
}

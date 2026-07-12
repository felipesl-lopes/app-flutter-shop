import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/categorias/models/categorias_model.dart';
import 'package:flutter/material.dart';

class AvaliacaoRepository {
  final IHttpClient _client;

  AvaliacaoRepository(this._client);

  Future<List<CategoriasModel>> carregarCategorias({
    required String userId,
  }) async {
    debugPrint('[CategoriasRepository]: carregarCategorias');

    try {
      final response = await _client.get('categories');

      if (response.statusCode > 400 || response.data == null) {
        return [];
      }

      final data = response.data as List;

      final categorias = data.map((e) {
        return CategoriasModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return categorias;
    } catch (e) {
      throw Exception('Erro ao carregar categorias.');
    }
  }

  Future<String> enviarAvaliacao({
    required String userId,
    required String comentario,
    required double nota,
    required String productId,
    required String orderId,
  }) async {
    debugPrint('[AvaliacaoRepository]: enviarAvaliacao');

    try {
      final response = await _client.post('avaliacao/$productId', body: {
        'usuarioId': userId,
        'nota': nota,
        'comentario': comentario,
        'orderId': orderId,
      });

      if (response.statusCode > 400 || response.data == null) {
        return throw Exception("Erro ao realizar avaliação.");
      }

      return response.data;
    } catch (e) {
      throw Exception('Erro ao realizar avaliação.');
    }
  }
}

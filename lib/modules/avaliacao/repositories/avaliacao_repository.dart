import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/avaliacao/models/avaliacao_model.dart';
import 'package:flutter/material.dart';

class AvaliacaoRepository {
  final IHttpClient _client;

  AvaliacaoRepository(this._client);

  Future<List<AvaliacaoModel>> carregarAvaliacoesPorProduto({
    required String productId,
  }) async {
    debugPrint('[AvaliacaoRepository]: carregarAvaliacoesPorProduto');

    try {
      final response = await _client.get('avaliacao/$productId');

      if (response.statusCode > 400 || response.data == null) {
        return [];
      }

      final data = response.data as List;

      final avaliacoes = data.map((e) {
        return AvaliacaoModel.fromMap(Map<String, dynamic>.from(e));
      }).toList();

      return avaliacoes;
    } catch (e) {
      throw Exception('Erro ao carregar avaliações.');
    }
  }

  Future<Map<String, dynamic>> enviarAvaliacao({
    required String comentario,
    required double nota,
    required String productId,
    required String orderId,
  }) async {
    debugPrint('[AvaliacaoRepository]: enviarAvaliacao');

    try {
      final response = await _client.post('avaliacao/$productId', body: {
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

    Future<Map<String, dynamic>> editarAvaliacao({
    required String comentario,
    required double nota,
    required String productId,
    required String avaliacaoId,
  }) async {
    debugPrint('[AvaliacaoRepository]: editarAvaliacao');

    try {
      final response = await _client.put('avaliacao/$productId', body: {
        'nota': nota,
        'comentario': comentario,
        'avaliacaoId': avaliacaoId,
      });

      if (response.statusCode > 400 || response.data == null) {
        return throw Exception("Erro ao atualizar avaliação.");
      }

      return response.data;
    } catch (e) {
      throw Exception('Erro ao atualizar avaliação.');
    }
  }
}

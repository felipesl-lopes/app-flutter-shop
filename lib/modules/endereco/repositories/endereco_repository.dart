import 'dart:io';

import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:flutter/material.dart';

class EnderecoRepository {
  final IHttpClient _client;

  EnderecoRepository(this._client);

  Future<List<EnderecoModel>> carregarEnderecos({
    required String userId,
  }) async {
    debugPrint('[CartRepository]: carregarEnderecos');

    try {
      final response = await _client.get('address/$userId');
      final data = response.data;

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao buscar endereços');
      }

      if (data == null) return [];

      final enderecos = (response.data as List)
          .map((e) => EnderecoModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return enderecos;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao carregar endereços.');
    }
  }

  Future<EnderecoModel> buscarEndereco({
    required String userId,
    required String enderecoId,
  }) async {
    debugPrint('[CartRepository]: buscarEndereco');

    try {
      final response = await _client.get('address/$userId/$enderecoId');

      final Map<String, dynamic> data = response.data;

      return EnderecoModel.fromMap(data);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao buscar endereço');
    }
  }

  Future<void> adicionarEndereco({
    required String userId,
    required EnderecoModel endereco,
  }) async {
    debugPrint('[CartRepository]: adicionarEndereco');

    try {
      final response = await _client.post(
        'address/$userId',
        body: endereco.toMap(),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao adicionar endereço');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao adicionar endereço.');
    }
  }

  Future<void> editarEndereco({
    required String userId,
    required EnderecoModel endereco,
  }) async {
    debugPrint('[CartRepository]: editarEndereco');

    try {
      final response = await _client.put(
        'address/$userId/${endereco.id}',
        body: endereco.toMap(),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao editar endereço');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao editar endereço.');
    }
  }

  Future<void> removerEndereco({required String userId}) async {
    debugPrint('[CartRepository]: removerEndereco');

    try {} catch (_) {
      throw Exception('Erro ao remover endereço.');
    }
  }
}

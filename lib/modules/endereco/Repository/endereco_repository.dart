import 'dart:io';

import 'package:appshop/shared/Models/endereco_model.dart';
import 'package:appshop/shared/services/i_http_client.dart';
import 'package:flutter/material.dart';

class EnderecoRepository {
  final IHttpClient client;

  EnderecoRepository(this.client);

  Future<List<EnderecoModel>> carregarEnderecos({
    required String userId,
  }) async {
    debugPrint('[CartRepository]: carregarEnderecos');

    try {
      final response = await client.get('address/$userId');

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao buscar endereços');
      }

      if (response.data == null) return [];

      final Map<String, dynamic> data =
          Map<String, dynamic>.from(response.data);

      final List<EnderecoModel> enderecos = [];

      data.forEach((id, enderecoData) {
        enderecos.add(
          EnderecoModel.fromMap(
            id,
            Map<String, dynamic>.from(enderecoData),
          ),
        );
      });

      return enderecos;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao carregar endereços.');
    }
  }

  Future<void> adicionarEndereco({
    required String userId,
    required EnderecoModel endereco,
  }) async {
    debugPrint('[CartRepository]: adicionarEndereco');

    final body = {
      'cep': endereco.cep,
      'rua': endereco.rua,
      'numero': endereco.numero,
      'complemento': endereco.complemento,
      'bairro': endereco.bairro,
      'cidade': endereco.cidade,
      'uf': endereco.uf,
    };

    try {
      final response = await client.post('address/$userId', body: body);

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao adicionar endereço');
      }

      final data = response.data;
      return data['name'];
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

    final body = {
      'cep': endereco.cep,
      'rua': endereco.rua,
      'numero': endereco.numero,
      'complemento': endereco.complemento,
      'bairro': endereco.bairro,
      'cidade': endereco.cidade,
      'uf': endereco.uf,
    };

    try {
      final response = await client.put(
        'address/$userId/${endereco.id}',
        body: body,
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

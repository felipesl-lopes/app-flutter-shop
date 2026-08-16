import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/categorias/models/categorias_model.dart';
import 'package:flutter/material.dart';

class CategoriasRepository {
  final IHttpClient _client;

  CategoriasRepository(this._client);

  Future<List<CategoriasModel>> carregarCategorias() async {
    debugPrint('[CategoriasRepository]: carregarCategorias');

    try {
      final response = await _client.get('categories');

      if (response.statusCode > 400 || response.data == null) {
        return [];
      }

      final categorias = (response.data as List).map((e) {
        return CategoriasModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();

      return categorias;
    } catch (e) {
      debugPrint('Erro ao carregar categorias: ' + e.toString());
      throw Exception('Erro ao carregar categorias.');
    }
  }
}

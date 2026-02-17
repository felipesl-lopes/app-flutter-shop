import 'dart:convert';

import 'package:appshop/core/utils/constants.dart';
import 'package:appshop/features/categorias/Models/categorias_model.dart';
import 'package:http/http.dart' as http;

class CategoriasRepository {
  final String token;
  final String userId;

  CategoriasRepository({
    required this.token,
    required this.userId,
  });

  Future<List<CategoriasModel>> carregarCategorias() async {
    final response = await http
        .get(Uri.parse("${Constants.PRODUCT_CATEGORIES}.json?auth=$token"));

    if (response.body == "null") {
      return [];
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    final List<CategoriasModel> categorias = [];

    data.forEach((id, value) {
      categorias.add(
        CategoriasModel(
          id: id,
          nome: value['name'],
        ),
      );
    });

    return categorias;
  }
}

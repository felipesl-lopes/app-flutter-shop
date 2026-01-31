import 'dart:convert';
import 'dart:io';

import 'package:appshop/core/utils/constants.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  Future<Map<String, dynamic>> loadOrdersRepository({
    required String userId,
    required String token,
  }) async {
    final response = await http.get(
        Uri.parse("${Constants.ORDERS_BASE_URL}/$userId.json?auth=$token"));

    if (response.statusCode >= 400) {
      throw HttpException('Erro ao buscar pedidos');
    }

    if (response.body == "null") return {};

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<String> addOrderRepository({
    required String userId,
    required String token,
    required double total,
    required DateTime date,
    required List<Map<String, dynamic>> products,
  }) async {
    final response = await http.post(
      Uri.parse("${Constants.ORDERS_BASE_URL}/$userId.json?auth=$token"),
      body: jsonEncode(
        {
          "total": total,
          "date": date.toIso8601String(),
          "products": products,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw HttpException('Erro ao adicionar pedido');
    }

    final data = jsonDecode(response.body);
    return data['name'];
  }
}

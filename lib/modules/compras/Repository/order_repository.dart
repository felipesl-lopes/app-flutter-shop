import 'dart:io';

import 'package:appshop/shared/services/i_http_client.dart';

class OrderRepository {
  final IHttpClient client;

  OrderRepository(this.client);

  Future<Map<String, dynamic>> loadOrdersRepository({
    required String userId,
  }) async {
    final response = await client.get('orders/$userId');

    if (response.statusCode >= 400) {
      throw HttpException('Erro ao buscar pedidos');
    }

    if (response.data == null) return {};
    return response.data;
  }

  Future<String> addOrderRepository({
    required String userId,
    required double total,
    required DateTime date,
    required List<Map<String, dynamic>> products,
  }) async {
    final body = {
      "total": total,
      "date": date.toIso8601String(),
      "products": products,
    };

    final response = await client.post('orders/$userId', body: body);

    if (response.statusCode >= 400) {
      throw HttpException('Erro ao adicionar pedido');
    }

    final data = response.data;
    return data['name'];
  }
}

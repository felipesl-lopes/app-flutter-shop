import 'dart:io';

import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/compras/models/order.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:flutter/material.dart';

class OrderRepository {
  final IHttpClient _client;

  OrderRepository(this._client);

  Future<List<Order>> loadOrdersRepository({
    required String userId,
  }) async {
    debugPrint('[OrderRepository]: loadOrdersRepository');

    try {
      final response = await _client.get('orders/$userId');

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao buscar pedidos');
      }

      final data = response.data;

      if (response.data == null) return [];

      final orders = (data as List)
          .map((e) => Order.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return orders;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao carregar compras.');
    }
  }

  Future<String> finalizarCompraRepository({
    required String userId,
    required double total,
    required DateTime date,
    required List<Map<String, dynamic>> products,
    required EnderecoModel endereco,
  }) async {
    debugPrint('[OrderRepository]: addOrderRepository');

    final body = {
      "total": total,
      "date": date.toIso8601String(),
      "products": products,
      "address": endereco.toMap(),
    };

    try {
      final response = await _client.post('orders/$userId', body: body);

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao adicionar pedido');
      }

      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Erro ao finalizar compras.');
    }
  }
}

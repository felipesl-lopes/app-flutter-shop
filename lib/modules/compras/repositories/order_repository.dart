import 'dart:io';

import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';
import 'package:flutter/material.dart';

class OrderRepository {
  final IHttpClient client;

  OrderRepository(this.client);

  Future<Map<String, dynamic>> loadOrdersRepository({
    required String userId,
  }) async {
    debugPrint('[OrderRepository]: loadOrdersRepository');

    try {
      final response = await client.get('orders/$userId');

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao buscar pedidos');
      }

      if (response.data == null) return {};

      return response.data;
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
      final response = await client.post('orders/$userId', body: body);

      if (response.statusCode >= 400) {
        throw HttpException('Erro ao adicionar pedido');
      }

      final data = response.data;
      return data['name'];
    } catch (_) {
      throw Exception('Erro ao finalizar compras.');
    }
  }
}

import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/compras/models/order.dart';
import 'package:appshop/modules/compras/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class OrderListProvider with ChangeNotifier {
  final AuthProvider _auth;
  final OrderRepository _orderRepository;

  late final Command0<List<Order>> loadOrdersCommand;

  OrderListProvider(
    this._auth,
    this._orderRepository,
  ) {
    loadOrdersCommand = Command0(_loadOrders);
  }

  List<Order> _items = [];

  String get _userId => _auth.userId ?? '';

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void setOrders(List<Order> value) {
    _items = value;
    notifyListeners();
  }

  Future<Result<List<Order>>> _loadOrders() async {
    try {
      final data = await _orderRepository.loadOrdersRepository(userId: _userId);

      setOrders(data.reversed.toList());

      return Success(data);
    } catch (e) {
      return Failure(
        Exception(e.toString()),
      );
    }
  }

  Future<void> finalizarCompra(CartProvider cart, String enderecoId) async {
    await _orderRepository.finalizarCompraRepository(
      userId: _userId,
      addressId: enderecoId,
    );

    cart.limparCarrinho();
    notifyListeners();
  }
}

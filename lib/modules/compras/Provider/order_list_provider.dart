import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/modules/compras/Repository/order_repository.dart';
import 'package:appshop/shared/Models/order.dart';
import 'package:flutter/material.dart';

class OrderListProvider with ChangeNotifier {
  final AuthProvider auth;
  final CartRepository _cartRepository;
  final OrderRepository _repository;

  OrderListProvider(
    this.auth,
    this._cartRepository,
    this._repository,
  );

  List<Order> _items = [];

  String get _userId => auth.userId ?? '';

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    try {
      final data = await _repository.loadOrdersRepository(userId: _userId);

      List<Order> items = [];

      data.forEach((orderId, orderData) {
        items.add(
          Order(
            id: orderId,
            date: DateTime.parse(orderData["date"]),
            total: (orderData["total"] as num).toDouble(),
            products: (orderData["products"] as List)
                .map((item) => ComprasModel.fromMap(
                      Map<String, dynamic>.from(item),
                    ))
                .toList(),
          ),
        );
      });

      _items = items.reversed.toList();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> addOrder(CartProvider cart) async {
    final date = DateTime.now();

    final List<ComprasModel> produtosPedido = cart.carrinhoDeProdutos
        .map((cartItem) => ComprasModel(
              id: cartItem.product.id,
              name: cartItem.product.name,
              quantity: cartItem.quantity,
              price: cartItem.product.valorFinalDoProduto(),
              imageUrl: cartItem.product.imageUrls.first.toString(),
            ))
        .toList();

    final productsMap = produtosPedido
        .map((p) => {
              'id': p.id,
              'name': p.name,
              'quantity': p.quantity,
              'price': p.price,
              'imageUrl': p.imageUrl,
            })
        .toList();

    final orderId = await _repository.addOrderRepository(
      userId: _userId,
      total: cart.valorTotal,
      date: date,
      products: productsMap,
    );

    _items.insert(
      0,
      Order(
        id: orderId,
        total: cart.valorTotal,
        date: date,
        products: produtosPedido,
      ),
    );

    await _cartRepository.limparCarrinho(userId: _userId);
    cart.limparCarrinho();
    notifyListeners();
  }
}

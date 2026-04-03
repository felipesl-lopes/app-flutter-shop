import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/modules/compras/Repository/order_repository.dart';
import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/Models/order.dart';
import 'package:flutter/material.dart';

class OrderListProvider with ChangeNotifier {
  final AuthProvider auth;
  final CartRepository _cartRepository;

  List<Order> _items = [];
  final _repository = OrderRepository();

  OrderListProvider(this.auth, this._cartRepository);

  String get _token => auth.token ?? '';
  String get _userId => auth.userId ?? '';

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    final data =
        await _repository.loadOrdersRepository(userId: _userId, token: _token);

    List<Order> items = [];

    data.forEach(
      (orderId, orderData) {
        items.add(Order(
          id: orderId,
          date: DateTime.parse(orderData["date"]),
          total: orderData["total"],
          products: (orderData["products"] as List<dynamic>).map(
            (item) {
              return CartItemModel(
                id: item["id"],
                name: item["name"],
                quantity: item["quantity"],
                price: item["price"],
                imageUrl: item["imageUrl"] ?? "",
              );
            },
          ).toList(),
        ));
      },
    );

    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(CartProvider cart) async {
    final date = DateTime.now();

    final products = cart.items
        .map((cartItem) => {
              'id': cartItem.id,
              'name': cartItem.name,
              'quantity': cartItem.quantity,
              'price': cartItem.price,
              'imageUrl': cartItem.imageUrl,
            })
        .toList();

    final orderId = await _repository.addOrderRepository(
      userId: _userId,
      token: _token,
      total: cart.totalAmount,
      date: date,
      products: products,
    );

    _items.insert(
      0,
      Order(
        id: orderId,
        total: cart.totalAmount,
        date: date,
        products: cart.items.toList(),
      ),
    );

    await _cartRepository.limparCarrinho(userId: _userId);

    cart.clear();
    notifyListeners();
  }
}

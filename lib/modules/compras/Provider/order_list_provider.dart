import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/modules/compras/Repository/order_repository.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/shared/Models/cart_item_model.dart';
import 'package:appshop/shared/Models/order.dart';
import 'package:flutter/material.dart';

class OrderListProvider with ChangeNotifier {
  final AuthProvider auth;
  final CartRepository _cartRepository;
  final OrderRepository _repository;
  final ProductProvider _productProvider;

  OrderListProvider(
    this.auth,
    this._cartRepository,
    this._repository,
    this._productProvider,
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
      final data = await _repository.loadOrdersRepository(
        userId: _userId,
      );

      final productsMap = {
        for (var p in _productProvider.produtos) p.id: p,
      };

      List<Order> items = [];

      data.forEach((orderId, orderData) {
        items.add(
          Order(
            id: orderId,
            date: DateTime.parse(orderData["date"]),
            total: orderData["total"],
            products: (orderData["products"] as List<dynamic>)
                .map((item) {
                  final product = productsMap[item['id']];

                  if (product == null) return null;

                  return CartItemModel(
                    product: product,
                    quantity: item['quantity'],
                  );
                })
                .whereType<CartItemModel>()
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

    final products = cart.items
        .map((cartItem) => {
              'id': cartItem.product.id,
              'name': cartItem.product.name,
              'quantity': cartItem.quantity,
              'price': cartItem.product.price,
              'imageUrl': cartItem.product.imageUrls.first,
            })
        .toList();

    final orderId = await _repository.addOrderRepository(
      userId: _userId,
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

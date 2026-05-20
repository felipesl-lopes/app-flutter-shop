import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/cart/Repository/cart_repository.dart';
import 'package:appshop/modules/compras/Repository/order_repository.dart';
import 'package:appshop/modules/endereco/Repository/endereco_repository.dart';
import 'package:appshop/shared/Models/endereco_model.dart';
import 'package:appshop/shared/Models/order.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class OrderListProvider with ChangeNotifier {
  final AuthProvider _auth;
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;
  final EnderecoRepository _enderecoRepository;

  late final Command0<List<Order>> loadOrdersCommand;

  OrderListProvider(
    this._auth,
    this._cartRepository,
    this._orderRepository,
    this._enderecoRepository,
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

      List<Order> items = [];

      data.forEach((orderId, orderData) {
        items.add(Order(
          id: orderId,
          date: DateTime.parse(orderData["date"]),
          total: (orderData["total"] as num).toDouble(),
          products: (orderData["products"] as List)
              .map((item) => ComprasModel.fromMap(
                    Map<String, dynamic>.from(item),
                  ))
              .toList(),
          endereco: orderData['address'] != null
              ? EnderecoModel.fromMap(orderData['address']['id'] ?? '',
                  Map<String, dynamic>.from(orderData['address']))
              : null,
        ));
      });

      setOrders(items.reversed.toList());

      return Success(_items);
    } catch (e) {
      return Failure(
        Exception(e.toString()),
      );
    }
  }

  Future<void> addOrder(CartProvider cart, String enderecoId) async {
    final date = DateTime.now();

    final responseEndereco = await _enderecoRepository.buscarEndereco(
        userId: _auth.userId!, enderecoId: enderecoId);

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

    final orderId = await _orderRepository.addOrderRepository(
      userId: _userId,
      total: cart.valorTotal,
      date: date,
      endereco: responseEndereco,
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

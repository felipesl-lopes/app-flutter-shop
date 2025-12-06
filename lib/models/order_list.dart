import 'dart:convert';

import 'package:appshop/models/cart.dart';
import 'package:appshop/models/cart_item.dart';
import 'package:appshop/models/order.dart';
import 'package:appshop/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([
    this._token = "",
    this._userId = "",
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];
    final response = await http.get(
        Uri.parse("${Constants.ORDERS_BASE_URL}/$_userId.json?auth=$_token"));

    if (response.body == "null") return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach(
      (orderId, orderData) {
        items.add(Order(
          id: orderId,
          date: DateTime.parse(orderData["date"]),
          total: orderData["total"],
          products: (orderData["products"] as List<dynamic>).map(
            (item) {
              return CartItem(
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

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse("${Constants.ORDERS_BASE_URL}/$_userId.json?auth=$_token"),
      body: jsonEncode(
        {
          "total": cart.totalAmount,
          "date": date.toIso8601String(),
          "products": cart.items.values
              .map(
                (cartItem) => {
                  "id": cartItem.id,
                  "name": cartItem.name,
                  "quantity": cartItem.quantity,
                  "price": cartItem.price,
                  "imageUrl": cartItem.imageUrl,
                },
              )
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)["name"];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}

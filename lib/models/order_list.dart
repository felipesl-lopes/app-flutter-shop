import 'dart:convert';

import 'package:appshop/models/cart.dart';
import 'package:appshop/models/cart_item.dart';
import 'package:appshop/models/order.dart';
import 'package:appshop/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    final response =
        await http.get(Uri.parse("${Constants.ORDER_BASE_URL}.json"));

    if (response.body == "null") return;

    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();

    data.forEach(
      (orderId, orderData) {
        _items.add(Order(
          id: orderId,
          date: DateTime.parse(orderData["date"]),
          total: orderData["total"],
          products: (orderData["products"] as List<dynamic>).map(
            (item) {
              return CartItem(
                id: item["id"],
                productId: item["productId"],
                name: item["name"],
                quantity: item["quantity"],
                price: item["price"],
              );
            },
          ).toList(),
        ));
      },
    );
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse("${Constants.ORDER_BASE_URL}.json"),
      body: jsonEncode(
        {
          "total": cart.totalAmount,
          "date": date.toIso8601String(),
          "products": cart.items.values
              .map(
                (cartItem) => {
                  "id": cartItem.id,
                  "productId": cartItem.productId,
                  "name": cartItem.name,
                  "quantity": cartItem.quantity,
                  "price": cartItem.price,
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

import 'package:appshop/features/cart/Models/cart_item_model.dart';

class Order {
  final String id;
  final double total;
  final List<CartItemModel> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}

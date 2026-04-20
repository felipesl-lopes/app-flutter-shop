import 'package:appshop/shared/Models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });

  factory CartItemModel.fromJson(
    Map<String, dynamic> json,
    ProductModel product,
  ) {
    return CartItemModel(
      product: product,
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.id,
      'quantity': quantity,
    };
  }
}

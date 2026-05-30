import 'dart:convert';

import 'package:appshop/shared/Models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.id,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(
      Map<String, dynamic> map, ProductModel product) {
    return CartItemModel(
      product: product,
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source, ProductModel product) =>
      CartItemModel.fromMap(
          json.decode(source) as Map<String, dynamic>, product);

  @override
  String toString() => 'CartItemModel(product: $product, quantity: $quantity)';

  @override
  bool operator ==(covariant CartItemModel other) {
    if (identical(this, other)) return true;

    return other.product == product && other.quantity == quantity;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}

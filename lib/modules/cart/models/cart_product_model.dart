import 'dart:convert';

import 'package:appshop/modules/product/models/product_model.dart';

class CartProductModel {
  final ProductModel product;
  final int quantity;

  CartProductModel({
    required this.product,
    required this.quantity,
  });

  CartProductModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartProductModel(
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

  factory CartProductModel.fromMap(
      Map<String, dynamic> map, ProductModel product) {
    return CartProductModel(
      product: product,
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartProductModel.fromJson(String source, ProductModel product) =>
      CartProductModel.fromMap(
          json.decode(source) as Map<String, dynamic>, product);

  @override
  String toString() => 'CartItemModel(product: $product, quantity: $quantity)';

  @override
  bool operator ==(covariant CartProductModel other) {
    if (identical(this, other)) return true;

    return other.product == product && other.quantity == quantity;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}

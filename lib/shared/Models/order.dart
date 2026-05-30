import 'dart:convert';

import 'package:appshop/shared/Models/endereco_model.dart';

class Order {
  final String id;
  final double total;
  final List<ComprasModel> products;
  final DateTime date;
  final EnderecoModel? endereco;
  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
    this.endereco,
  });
}

class ComprasModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  ComprasModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  ComprasModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return ComprasModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  factory ComprasModel.fromMap(Map<String, dynamic> map) {
    return ComprasModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ComprasModel.fromJson(String source) =>
      ComprasModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ComprasModel(id: $id, name: $name, imageUrl: $imageUrl, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant ComprasModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.price == price &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        price.hashCode ^
        quantity.hashCode;
  }
}

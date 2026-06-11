import 'dart:convert';

import 'package:appshop/modules/product/models/product_image_model.dart';
import 'package:flutter/foundation.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<ProductImageModel> imageUrls;
  final List<String> categories;
  final String userId;
  final int quantity;
  bool isFavorite;
  final bool isPromotional;
  final int? discountPercentage;
  final DateTime? promotionEndDate;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.categories,
    required this.userId,
    required this.quantity,
    this.isFavorite = false,
    this.isPromotional = false,
    this.discountPercentage,
    this.promotionEndDate,
  });

  double valorFinalDoProduto() {
    final _percentage = double.tryParse(
          discountPercentage.toString().replaceAll(',', '.').trim(),
        ) ??
        0.0;

    final _price = double.tryParse(
          price.toString().replaceAll(',', '.').trim(),
        ) ??
        0.0;

    if (isPromotional) return _price * (1 - (_percentage / 100));
    return price;
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<ProductImageModel>? imageUrls,
    List<String>? categories,
    String? userId,
    int? quantity,
    bool? isFavorite,
    bool? isPromotional,
    int? Function()? discountPercentage,
    DateTime? Function()? promotionEndDate,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      categories: categories ?? this.categories,
      userId: userId ?? this.userId,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      isPromotional: isPromotional ?? this.isPromotional,
      discountPercentage: discountPercentage != null
          ? discountPercentage()
          : this.discountPercentage,
      promotionEndDate:
          promotionEndDate != null ? promotionEndDate() : this.promotionEndDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls.map((x) => x.toMap()).toList(),
      'categories': categories,
      'userId': userId,
      'quantity': quantity,
      'isFavorite': isFavorite,
      'isPromotional': isPromotional,
      'discountPercentage': discountPercentage,
      'promotionEndDate': promotionEndDate?.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      imageUrls: (map['imageUrls'] as List)
          .map((e) => ProductImageModel.fromMap(e))
          .toList(),
      categories:
          map['categories'] == null ? [] : List<String>.from(map['categories']),
      userId: map['userId'],
      quantity: map['quantity'] == null ? 1 : map['quantity'],
      isFavorite: map['isFavorite'] ?? false,
      isPromotional: map['isPromotional'] ?? false,
      discountPercentage: map['discountPercentage'] != null
          ? (map['discountPercentage'] as num).toInt()
          : null,
      promotionEndDate: map['promotionEndDate'] != null
          ? DateTime.parse(map['promotionEndDate'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String id, String source) =>
      ProductModel.fromMap(id, json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, price: $price, imageUrls: $imageUrls, categories: $categories, userId: $userId, quantity: $quantity, isFavorite: $isFavorite, isPromotional: $isPromotional, discountPercentage: $discountPercentage, promotionEndDate: $promotionEndDate)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        listEquals(other.imageUrls, imageUrls) &&
        listEquals(other.categories, categories) &&
        other.userId == userId &&
        other.quantity == quantity &&
        other.isFavorite == isFavorite &&
        other.isPromotional == isPromotional &&
        other.discountPercentage == discountPercentage &&
        other.promotionEndDate == promotionEndDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        imageUrls.hashCode ^
        categories.hashCode ^
        userId.hashCode ^
        quantity.hashCode ^
        isFavorite.hashCode ^
        isPromotional.hashCode ^
        discountPercentage.hashCode ^
        promotionEndDate.hashCode;
  }
}

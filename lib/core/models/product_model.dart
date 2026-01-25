import 'package:appshop/core/models/product_image_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<ProductImageModel> imageUrls;
  final String userId;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.userId,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(String id, Map<String, dynamic> json) {
    return ProductModel(
      id: id,
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrls: (json['imageUrls'] as List)
          .map((e) => ProductImageModel.fromJson(e))
          .toList(),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls.map((e) => e.toJson()).toList(),
      'userId': userId,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? userId,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls,
      userId: userId ?? this.userId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
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
      userId: map['userId'],
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls.map((e) => e.toMap()).toList(),
      'userId': userId,
      'isFavorite': isFavorite,
    };
  }
}

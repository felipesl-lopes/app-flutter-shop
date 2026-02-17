import 'package:appshop/core/models/product_image_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<ProductImageModel> imageUrls;
  final List<String> categories;
  final String userId;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.categories,
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
      categories: json['categories'] == null
          ? []
          : List<String>.from(json['categories']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toString()).toList(),
      'userId': userId,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? categories,
    String? userId,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls,
      categories: categories ?? this.categories,
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
      categories:
          map['categories'] == null ? [] : List<String>.from(map['categories']),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls.map((e) => e.toMap()).toList(),
      'categories': categories,
      'userId': userId,
      'isFavorite': isFavorite,
    };
  }
}

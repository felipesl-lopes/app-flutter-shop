class ProductImageModel {
  final String id;
  final String value;

  ProductImageModel({
    required this.id,
    required this.value,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }

  ProductImageModel copyWith({
    String? id,
    String? value,
  }) {
    return ProductImageModel(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  factory ProductImageModel.fromMap(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
    };
  }
}

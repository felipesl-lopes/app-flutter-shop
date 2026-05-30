import 'dart:convert';

class ProductImageModel {
  final String id;
  final String value;

  ProductImageModel({
    required this.id,
    required this.value,
  });

  ProductImageModel copyWith({
    String? id,
    String? value,
  }) {
    return ProductImageModel(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
    };
  }

  factory ProductImageModel.fromMap(Map<String, dynamic> map) {
    return ProductImageModel(
      id: map['id'],
      value: map['value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductImageModel.fromJson(String source) =>
      ProductImageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductImageModel(id: $id, value: $value)';

  @override
  bool operator ==(covariant ProductImageModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}

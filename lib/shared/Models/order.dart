class Order {
  final String id;
  final double total;
  final List<ComprasModel> products;
  final DateTime date;
  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
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
  factory ComprasModel.fromMap(Map<String, dynamic> map) {
    return ComprasModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}

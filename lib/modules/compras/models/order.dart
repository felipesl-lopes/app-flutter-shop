import 'package:appshop/modules/compras/models/compras_model.dart';
import 'package:appshop/modules/endereco/models/endereco_model.dart';

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

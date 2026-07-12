import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:appshop/modules/avaliacao/repositories/avaliacao_repository.dart';
import 'package:appshop/modules/categorias/models/categorias_model.dart';
import 'package:appshop/modules/compras/providers/order_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

class AvaliacaoProvider with ChangeNotifier {
  final AuthProvider _auth;
  final AvaliacaoRepository _avaliacaoRepository;
  final OrderListProvider _orderListProvider;

  late final Command0<List<CategoriasModel>> loadCategoriesCommand;

  AvaliacaoProvider(
    this._auth,
    this._avaliacaoRepository,
    this._orderListProvider,
  );

  Future<String> enviarAvaliacao(
    String comentario,
    double nota,
    String productId,
    String orderId,
  ) async {
    try {
      final avaliacaoId = await _avaliacaoRepository.enviarAvaliacao(
        userId: _auth.userId ?? '',
        comentario: comentario,
        nota: nota,
        orderId: orderId,
        productId: productId,
      );

      final order = _orderListProvider.items.firstWhere((e) => e.id == orderId);

      final index = order.products.indexWhere((e) => e.id == productId);

      if (index != -1) {
        order.products[index] =
            order.products[index].copyWith(avaliacaoId: avaliacaoId);
      }

      notifyListeners();

      return avaliacaoId;
    } catch (e) {
      return e.toString();
    }
  }
}

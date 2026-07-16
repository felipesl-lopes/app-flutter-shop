import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:appshop/modules/avaliacao/models/avaliacao_model.dart';
import 'package:appshop/modules/avaliacao/repositories/avaliacao_repository.dart';
import 'package:appshop/modules/compras/providers/order_list_provider.dart';
import 'package:flutter/material.dart';

class AvaliacaoProvider with ChangeNotifier {
  final AuthProvider _auth;
  final AvaliacaoRepository _avaliacaoRepository;
  final OrderListProvider _orderListProvider;

  AvaliacaoProvider(
    this._auth,
    this._avaliacaoRepository,
    this._orderListProvider,
  );

  List<AvaliacaoModel> _avaliacoes = [];
  List<AvaliacaoModel> get avaliacoes => [..._avaliacoes];

  bool _loadingAvaliacoes = false;
  bool get loadingAvaliacoes => _loadingAvaliacoes;

  void setLoadingAvaliacoes(bool value) {
    _loadingAvaliacoes = value;
    notifyListeners();
  }

  void setAvaliacoes(List<AvaliacaoModel> value) {
    _avaliacoes = value;
    notifyListeners();
  }

  Future<List<AvaliacaoModel>> carregarAvaliacoesPorProduto(
      String productId) async {
    setLoadingAvaliacoes(true);

    try {
      final list = await _avaliacaoRepository.carregarAvaliacoesPorProduto(
          userId: _auth.userId!, productId: productId);

      setAvaliacoes(list);

      return list;
    } catch (e) {
      return throw Exception(e);
    } finally {
      setLoadingAvaliacoes(false);
    }
  }

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

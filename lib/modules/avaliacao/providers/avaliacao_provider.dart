import 'package:appshop/modules/avaliacao/models/avaliacao_model.dart';
import 'package:appshop/modules/avaliacao/repositories/avaliacao_repository.dart';
import 'package:appshop/modules/compras/providers/order_list_provider.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:flutter/material.dart';

class AvaliacaoProvider with ChangeNotifier {
  final AvaliacaoRepository _avaliacaoRepository;
  final OrderListProvider _orderListProvider;
  final ProductProvider _productListProvider;

  AvaliacaoProvider(
    this._avaliacaoRepository,
    this._orderListProvider,
    this._productListProvider,
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
          productId: productId);

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
      final data = await _avaliacaoRepository.enviarAvaliacao(
        comentario: comentario,
        nota: nota,
        orderId: orderId,
        productId: productId,
      );

      final order = _orderListProvider.items.firstWhere((e) => e.id == orderId);

      final index = order.products.indexWhere((e) => e.id == productId);

      if (index != -1) {
        order.products[index] =
            order.products[index].copyWith(avaliacaoId: data['avaliacaoId']);
      }

      // metodo criado e chamado pois ProductProvider precisa ser notificado da alteração no produto.
      _productListProvider.atualizarAvaliacaoProduto(
        productId: productId,
        notaMedia: (data['notaMedia'] as num).toDouble(),
        totalAvaliacoes: data['totalAvaliacoes'],
      );

      notifyListeners();

      return data['avaliacaoId'];
    } catch (e) {
      return e.toString();
    }
  }
}

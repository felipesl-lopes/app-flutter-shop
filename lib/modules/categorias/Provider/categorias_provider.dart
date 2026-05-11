import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/categorias/Models/categorias_model.dart';
import 'package:appshop/modules/categorias/Repository/categorias_repository.dart';
import 'package:flutter/material.dart';

class CategoriasProvider with ChangeNotifier {
  final AuthProvider _auth;
  final CategoriasRepository _categoriasRepository;

  CategoriasProvider(
    this._auth,
    this._categoriasRepository,
  );

  List<CategoriasModel> _categorias = [];
  List<CategoriasModel> get categorias => [..._categorias];

  List<CategoriasModel> get principaisCategorias =>
      [..._categorias].take(8).toList();

  void setCategorias(value) {
    _categorias = value;
    notifyListeners();
  }

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriasRepository.carregarCategorias(
        userId: _auth.userId ?? '',
      );

      setCategorias(categorias);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<String> getNomesCategorias(List<String> categoryIds) {
    return _categorias
        .where((c) => categoryIds.contains(c.id))
        .map((c) => c.nome)
        .toList();
  }
}

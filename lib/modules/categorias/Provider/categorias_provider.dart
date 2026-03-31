import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/categorias/Models/categorias_model.dart';
import 'package:appshop/modules/categorias/Repository/categorias_repository.dart';
import 'package:flutter/material.dart';

class CategoriasProvider with ChangeNotifier {
  final AuthProvider auth;
  final CategoriasRepository _categoriasRepository;

  List<CategoriasModel> _categorias = [];

  CategoriasProvider(this.auth, this._categoriasRepository);

  String get _token => auth.token ?? '';
  String get _userId => auth.userId ?? '';

  List<CategoriasModel> get categorias => [..._categorias];

  List<CategoriasModel> get principaisCategorias =>
      [..._categorias].take(8).toList();

  void setCategorias(value) {
    _categorias = value;
    notifyListeners();
  }

  Future<void> carregarCategorias() async {
    final categorias = await _categoriasRepository.carregarCategorias(
      token: _token,
      userId: _userId,
    );

    setCategorias(categorias);
  }

  List<String> getNomesCategorias(List<String> categoryIds) {
    return _categorias
        .where((c) => categoryIds.contains(c.id))
        .map((c) => c.nome)
        .toList();
  }
}

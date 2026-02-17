import 'package:appshop/features/categorias/Models/categorias_model.dart';
import 'package:appshop/features/categorias/Repository/categorias_repository.dart';
import 'package:flutter/material.dart';

class CategoriasProvider with ChangeNotifier {
  final String _userId;
  final String _token;

  late final CategoriasRepository _repository;
  List<CategoriasModel> _categorias = [];

  CategoriasProvider([
    this._token = '',
    this._userId = '',
    this._categorias = const [],
  ]) {
    _repository = CategoriasRepository(token: _token, userId: _userId);
  }

  List<CategoriasModel> get categorias => [..._categorias];

  List<CategoriasModel> get principaisCategorias =>
      [..._categorias].take(8).toList();

  void setCategorias(value) {
    _categorias = value;
    notifyListeners();
  }

  Future<void> carregarCategorias() async {
    final categorias = await _repository.carregarCategorias();

    setCategorias(categorias);
  }
}

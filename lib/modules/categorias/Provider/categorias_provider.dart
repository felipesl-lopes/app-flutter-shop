import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/categorias/Models/categorias_model.dart';
import 'package:appshop/modules/categorias/Repository/categorias_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CategoriasProvider with ChangeNotifier {
  final AuthProvider _auth;
  final CategoriasRepository _categoriasRepository;

  late final Command0<List<CategoriasModel>> loadCategoriesCommand;

  CategoriasProvider(
    this._auth,
    this._categoriasRepository,
  ) {
    loadCategoriesCommand = Command0<List<CategoriasModel>>(
      _loadCategories,
    );
  }

  List<CategoriasModel> _categorias = [];
  List<CategoriasModel> get categorias => [..._categorias];

  List<CategoriasModel> get principaisCategorias =>
      [..._categorias].take(8).toList();

  void setCategorias(List<CategoriasModel> value) {
    _categorias = value;
    notifyListeners();
  }

  Future<Result<List<CategoriasModel>>> _loadCategories() async {
    try {
      final categorias = await _categoriasRepository.carregarCategorias(
        userId: _auth.userId ?? '',
      );

      setCategorias(categorias);
      return Success(categorias);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  List<String> getNomesCategorias(List<String> categoryIds) {
    return _categorias
        .where((c) => categoryIds.contains(c.id))
        .map((c) => c.nome)
        .toList();
  }
}

import 'dart:async';

import 'package:appshop/modules/auth/Provider/auth_provider.dart';
import 'package:appshop/modules/endereco/Repository/endereco_repository.dart';
import 'package:appshop/shared/Models/endereco_model.dart';
import 'package:flutter/material.dart';

class EnderecoProvider with ChangeNotifier {
  final AuthProvider _auth;
  final EnderecoRepository _enderecoRepository;

  EnderecoProvider(
    this._auth,
    this._enderecoRepository,
  );

  String get _userId => _auth.userId ?? '';

  List<EnderecoModel> _enderecos = [];
  List<EnderecoModel> get enderecos => [..._enderecos];

  void setEnderecos(List<EnderecoModel> value) {
    _enderecos = value;
    notifyListeners();
  }

  Future<List<EnderecoModel>> carregarEnderecos() async {
    try {
      final response = await _enderecoRepository.carregarEnderecos(
        userId: _userId,
      );

      setEnderecos(response);

      return response;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> adicionarEndereco(
    EnderecoModel endereco,
  ) async {
    try {
      await _enderecoRepository.adicionarEndereco(
        userId: _auth.userId!,
        endereco: endereco,
      );

      setEnderecos([..._enderecos, endereco]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editarEndereco(EnderecoModel endereco) async {
    try {
      await _enderecoRepository.editarEndereco(
          userId: _auth.userId!, endereco: endereco);

      final listaAtualizada = _enderecos.map((e) {
        return e.id == endereco.id ? endereco : e;
      }).toList();

      setEnderecos(listaAtualizada);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removerEndereco(String enderecoId) async {
    try {
      await _enderecoRepository.removerEndereco(userId: _userId);
    } catch (e) {}
  }
}

import 'dart:math';

import 'package:appshop/modules/product/models/product_image_model.dart';
import 'package:appshop/modules/product/models/product_model.dart';
import 'package:appshop/modules/product/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository;

  late final Command0<List<ProductModel>> loadProductsCommand;
  late final Command0<List<ProductModel>> loadMyProductsCommand;
  late final Command0<List<ProductModel>> loadFavoritesProductsCommand;

  List<ProductModel> _produtos = [];
  List<ProductModel> _meusProdutos = [];
  List<ProductModel> _produtosFavoritos = [];

  ProductProvider(
    this._productRepository,
  ) {
    loadProductsCommand = Command0(_loadProducts);
    loadMyProductsCommand = Command0(_loadMyProducts);
    loadFavoritesProductsCommand = Command0(_loadFavoritesProducts);
  }

  List<ProductModel> get produtos => [..._produtos];
  List<ProductModel> get meusProdutos => [..._meusProdutos];
  List<ProductModel> get produtosFavoritos => [..._produtosFavoritos];

  List<ProductModel> get produtosEmOferta =>
      _produtos.where((p) => p.isPromotional).toList();

  List<ProductModel> get meusFavoritos =>
      _produtos.where((p) => p.isFavorite == true).toList();

  int get quantidadeDeProdutos {
    return _produtos.length;
  }

  void setProdutos(List<ProductModel> value) {
    _produtos = value;
    notifyListeners();
  }

  void setMeusProdutos(List<ProductModel> value) {
    _meusProdutos = value;
    notifyListeners();
  }

  void setProdutosFavoritos(List<ProductModel> value) {
    _produtosFavoritos = value;
    notifyListeners();
  }

  /**
   * Método void que recebe os dados de avaliação do produto atualizado.
   * Necessita notificar seu proprio listener para escutar a alteração.
   */
  void atualizarAvaliacaoProduto({
    required String productId,
    required double notaMedia,
    required int totalAvaliacoes,
  }) {
    final index = _produtos.indexWhere((e) => e.id == productId);

    if (index == -1) return;

    _produtos[index] = _produtos[index].copyWith(
      notaMedia: notaMedia,
      totalAvaliacoes: totalAvaliacoes,
    );

    notifyListeners();
  }

  Future<Result<List<ProductModel>>> _loadProducts() async {
    try {
      final produtos = await _productRepository.carregarProdutos();

      setProdutos(produtos);

      return Success(produtos);
    } catch (e) {
      debugPrint(e.toString());
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<List<ProductModel>>> _loadMyProducts() async {
    try {
      final produtos = await _productRepository.carregarMeusProdutos();

      setMeusProdutos(produtos);

      return Success(produtos);
    } catch (e) {
      debugPrint(e.toString());
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<List<ProductModel>>> _loadFavoritesProducts() async {
    try {
      final produtos = await _productRepository.carregarProdutosFavoritos();

      setProdutosFavoritos(produtos);

      return Success(produtos);
    } catch (e) {
      debugPrint(e.toString());
      return Failure(Exception(e.toString()));
    }
  }

  List<ProductModel> searchByName(String query) {
    final q = query.toLowerCase();

    final lista = _produtos.where((p) {
      return p.name.toLowerCase().contains(q);
    }).toList();

    return lista.toList();
  }

  List<ProductModel> produtosPorCategoria(String categoryId) {
    final lista = _produtos.where((p) {
      return p.categories.contains(categoryId);
    }).toList();

    return lista.toList();
  }

  Future<void> salvarProduto(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final isPromotional = data["isPromotional"] == true ||
        data["discountPercentage"] != null ||
        data["promotionEndDate"] != null ||
        data["promotionValidUntil"] != null;

    final promotionDateRaw =
        data["promotionEndDate"] ?? data["promotionValidUntil"];
    final DateTime? promotionEndDate = promotionDateRaw != null
        ? DateTime.parse(promotionDateRaw as String)
        : null;

    final newProduct = ProductModel(
      id: hasId ? data["id"].toString() : Random().nextDouble().toString(),
      name: data["name"] as String,
      description: data["description"] as String,
      price: data["price"] as double,
      quantity: data['quantity'] as int,
      imageUrls: data["imageUrls"] as List<ProductImageModel>,
      categories: List<String>.from(data['categories'] as List<String>),
      isPromotional: isPromotional,
      discountPercentage: data["discountPercentage"] as int?,
      promotionEndDate: promotionEndDate,
    );

    if (hasId) {
      return atualizarProduto(newProduct);
    } else {
      return adicionarProduto(newProduct);
    }
  }

  Future<void> adicionarProduto(ProductModel produto) async {
    final generateId = await _productRepository.adicionarProduto(produto);

    final novoProduto = produto.copyWith(id: generateId);

    setProdutos([..._produtos, novoProduto]);
  }

  Future<void> atualizarProduto(ProductModel produto) async {
    final data = await _productRepository.atualizarProduto(
      produto,
    );

    final lista = _meusProdutos.map((e) => e.id == data.id ? data : e).toList();

    setMeusProdutos(lista);
  }

  Future<void> deletarProduto(ProductModel produto) async {
    try {
      await _productRepository.deletarProduto(produto.id);
      final lista = _produtos.where((p) => p.id != produto.id).toList();
      setMeusProdutos(lista);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> adicionarOuRemoverFavorito(String productId) async {
    ProductModel? product;

    final indexProdutos = _produtos.indexWhere((p) => p.id == productId);

    if (indexProdutos != -1) {
      product = _produtos[indexProdutos];
    } else {
      final indexFavoritos =
          _produtosFavoritos.indexWhere((p) => p.id == productId);

      if (indexFavoritos != -1) {
        product = _meusProdutos[indexFavoritos];
      }
    }

    if (product == null) return;

    final oldValue = product.isFavorite;
    final isFavoritando = !oldValue;

    product.isFavorite = isFavoritando;
    notifyListeners();

    try {
      await _productRepository.adicionarOuRemoverFavorito(
        productId: productId,
        isFavorite: isFavoritando,
      );

      if (isFavoritando) {
        final exists = _produtosFavoritos.any((p) => p.id == productId);

        if (!exists) {
          _produtosFavoritos.add(product.copyWith(isFavorite: true));
        }
      } else {
        _produtosFavoritos.removeWhere((p) => p.id == productId);
      }

      notifyListeners();
    } catch (e) {
      product.isFavorite = oldValue;
      notifyListeners();
      rethrow;
    }
  }
}

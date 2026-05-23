import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/modules/product/widgets/product_grid.dart';
import 'package:appshop/modules/search/Models/search_model.dart';
import 'package:appshop/modules/search/Pages/modal_filtro_produto.dart';
import 'package:appshop/shared/Models/product_model.dart';
import 'package:appshop/shared/Widgets/badgee.dart';
import 'package:appshop/shared/Widgets/drawer_app_bar.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ProductModel> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasSearched = false;

  final ScrollController _scrollController = ScrollController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _visibleProducts = [];
  int _currentLimit = 10;

  bool _isInit = true;
  String? _initialQuery;
  String? _initialCategoryId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is SearchPageArgs) {
        if (args.query != null && args.query!.trim().isNotEmpty) {
          _searchController.text = args.query!;
          _initialQuery = args.query!.trim();
        }
        if (args.categoryId != null && args.categoryId!.isNotEmpty) {
          _initialCategoryId = args.categoryId;
        }
      }
      _isInit = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_paginationListener);

    Provider.of<ProductProvider>(context, listen: false)
        .loadProductsCommand
        .execute()
        .then((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      if (_initialCategoryId != null) {
        _filteredProducts = provider.produtosPorCategoria(_initialCategoryId!);
        _hasSearched = true;
      } else if (_initialQuery != null) {
        _filteredProducts = provider.searchByName(_initialQuery!);
        _hasSearched = true;
      }

      final products =
          _hasSearched ? _filteredProducts : provider.produtosParaCompra;

      _allProducts = products;
      _visibleProducts = _allProducts.take(_currentLimit).toList();

      setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _paginationListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_visibleProducts.length >= _allProducts.length) return;

    setState(() {
      _currentLimit += 10;
      _visibleProducts = _allProducts.take(_currentLimit).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    final productsToShow = _visibleProducts;

    void _searchProduct() {
      final query = _searchController.text.trim();
      if (query.isEmpty) return;

      setState(() {
        _hasSearched = true;
        _filteredProducts = provider.searchByName(query);
        _allProducts = _filteredProducts;
        _currentLimit = 10;
        _visibleProducts = _allProducts.take(_currentLimit).toList();
      });

      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: DrawerAppBar(
        titleWidget: TextField(
          controller: _searchController,
          autofocus: false,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: "Buscar produto",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              onPressed: _searchProduct,
              icon: Icon(Icons.search),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => modalFiltroProduto(context: context),
            icon: Icon(
              Icons.tune,
              color: Colors.white,
            ),
          ),
          Consumer<CartProvider>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART),
                icon: Icon(
                  Icons.shopping_cart,
                  color: AppColors.white,
                )),
            builder: (ctx, cart, child) => Badgee(
              value: cart.totalDeItens.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                if (_searchController.text.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Exibindo resultado de pesquisa para: ${_searchController.text}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                productsToShow.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Nenhum produto encontrado.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: ProductGrid(
                            list_products: productsToShow,
                            title: "Produtos para você",
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}

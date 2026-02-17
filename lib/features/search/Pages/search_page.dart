import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/widgets/product_grid.dart';
import 'package:appshop/features/search/Models/search_model.dart';
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
    Provider.of<ProductProvider>(context, listen: false)
        .carregarProdutos()
        .then((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);

      if (_initialCategoryId != null) {
        _filteredProducts = provider.produtosPorCategoria(_initialCategoryId!);
        _hasSearched = true;
      } else if (_initialQuery != null) {
        _filteredProducts = provider.searchByName(_initialQuery!);
        _hasSearched = true;
      }

      setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    final productsToShow =
        _hasSearched ? _filteredProducts : provider.produtosParaCompra;

    void _searchProduct() {
      final query = _searchController.text.trim();
      if (query.isEmpty) return;

      setState(() {
        _hasSearched = true;
        _filteredProducts = provider.searchByName(query);
      });

      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
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
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.tune,
                color: Colors.white,
              )),
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

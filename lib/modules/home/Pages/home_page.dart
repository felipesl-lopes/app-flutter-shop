import 'package:appshop/modules/cart/Provider/cart_provider.dart';
import 'package:appshop/modules/categorias/Provider/categorias_provider.dart';
import 'package:appshop/modules/endereco/Provider/endereco_provider.dart';
import 'package:appshop/modules/home/widgets/banner_carousel.dart';
import 'package:appshop/modules/home/widgets/card_incentivo_carrinho.dart';
import 'package:appshop/modules/home/widgets/category_roundels.dart';
import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/modules/product/widgets/product_grid.dart';
import 'package:appshop/modules/search/Models/search_model.dart';
import 'package:appshop/shared/Widgets/app_drawer.dart';
import 'package:appshop/shared/Widgets/badgee.dart';
import 'package:appshop/shared/Widgets/drawer_app_bar.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/repository/banners_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      context.read<CategoriasProvider>().loadCategoriesCommand.execute(),
      context.read<BannersProvider>().loadBannersCommand.execute(),
      context.read<CartProvider>().loadCartCommand.execute(),
      context.read<EnderecoProvider>().loadAddressCommand.execute(),
      context.read<ProductProvider>().loadProductsCommand.execute(),
    ]);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchProduct() {
    final query = _searchController.text.trim();

    if (query.isEmpty) return;

    _searchController.clear();

    Navigator.of(context).pushNamed(
      AppRoutes.SEARCH_PRODUCT,
      arguments: SearchPageArgs(query: query),
    );
  }

  void _searchProductCategory(String categoryId) {
    Navigator.of(context).pushNamed(
      AppRoutes.SEARCH_PRODUCT,
      arguments: SearchPageArgs(categoryId: categoryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtosProvider = context.watch<ProductProvider>();
    final bannersProvider = context.watch<BannersProvider>();
    final categoriasProvider = context.watch<CategoriasProvider>();

    final productsValue = produtosProvider.loadProductsCommand.value;
    final bannersValue = bannersProvider.loadBannersCommand.value;
    final categoriasValue = categoriasProvider.loadCategoriesCommand.value;

    final isLoading = productsValue.isIdle ||
        productsValue.isRunning ||
        bannersValue.isIdle ||
        bannersValue.isRunning ||
        categoriasValue.isIdle ||
        categoriasValue.isRunning;

    final categorias = categoriasProvider.principaisCategorias.toList();
    final produtosEmOferta = produtosProvider.produtosEmOferta;

    return Scaffold(
      appBar: DrawerAppBar(
        titleWidget: TextField(
          controller: _searchController,
          autofocus: false,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            hintText: "Buscar produto",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
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
          Consumer<CartProvider>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            builder: (ctx, cart, child) {
              return Badgee(
                value: cart.totalDeItens.toString(),
                child: child!,
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Theme.of(context).colorScheme.background,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BannerCarousel(
                        bannerList: bannersProvider.items,
                      ),
                      SizedBox(height: 12),
                      CategoryRoundels(
                        categorias: categorias,
                        onCategorySelected: _searchProductCategory,
                      ),
                      if (produtosProvider.meusFavoritos.isNotEmpty)
                        ProductGrid(
                          list_products: produtosProvider.meusFavoritos,
                          quantityGrid: 4,
                          title: "Seus favoritos",
                          gridHorizontal: true,
                        ),
                      CardIncentivoCarrinho(),
                      if (produtosProvider.produtosParaCompra.isEmpty)
                        Text(
                          "Nenhum produto encontrado",
                        )
                      else
                        ProductGrid(
                          list_products: produtosProvider.produtosParaCompra,
                          quantityGrid: 6,
                          title: "Produtos para você",
                        ),
                      SizedBox(height: 16),
                      if (produtosEmOferta.isNotEmpty)
                        ProductGrid(
                          list_products: produtosEmOferta,
                          quantityGrid: 6,
                          title: "Produtos em oferta",
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

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
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/repository/banners_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final categorias = Provider.of<CategoriasProvider>(context, listen: false);
    final banners = Provider.of<BannersProvider>(context, listen: false);
    final produtos = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final enderecos = Provider.of<EnderecoProvider>(context, listen: false);

    categorias.carregarCategorias();
    banners.loadBanners();
    cart.carregarCarrinho();
    enderecos.carregarEnderecos();

    produtos.carregarProdutos().then((_) {
      setState(() => _isLoading = false);
    });
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
    final _listaDeProdutos = Provider.of<ProductProvider>(context);
    final _categorias =
        Provider.of<CategoriasProvider>(context).principaisCategorias.toList();

    final _produtosEmOferta = _listaDeProdutos.produtosEmOferta;

    return Scaffold(
      appBar: DrawerAppBar(
        titleWidget: TextField(
          controller: _searchController,
          autofocus: false,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            fillColor: AppColors.white,
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
      drawer: AppDrawer(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: AppColors.grey.withOpacity(0.09),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<BannersProvider>(
                        builder: (ctx, bannersProvider, child) {
                          return BannerCarousel(
                              bannerList: bannersProvider.items);
                        },
                      ),
                      SizedBox(height: 12),
                      CategoryRoundels(
                        categorias: _categorias,
                        onCategorySelected: _searchProductCategory,
                      ),
                      if (_listaDeProdutos.meusFavoritos.isNotEmpty)
                        ProductGrid(
                          list_products: _listaDeProdutos.meusFavoritos,
                          quantityGrid: 4,
                          title: "Seus favoritos",
                          gridHorizontal: true,
                        ),
                      CardIncentivoCarrinho(),
                      if (_listaDeProdutos.produtosParaCompra.isEmpty) ...[
                        Text("Nenhum produto encontrado")
                      ] else ...[
                        ProductGrid(
                          list_products: _listaDeProdutos.produtosParaCompra,
                          quantityGrid: 6,
                          title: "Produtos para você",
                        ),
                      ],
                      SizedBox(height: 16),
                      if (_produtosEmOferta.isNotEmpty)
                        ProductGrid(
                          list_products: _produtosEmOferta,
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

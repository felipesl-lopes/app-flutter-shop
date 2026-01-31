import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/features/cart/Provider/cart_provider.dart';
import 'package:appshop/features/home/widgets/banner_carousel.dart';
import 'package:appshop/features/home/widgets/category_roundels.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/widgets/product_grid.dart';
import 'package:appshop/shared/Widgets/app_drawer.dart';
import 'package:appshop/shared/Widgets/badgee.dart';
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
    Provider.of<BannersProvider>(context, listen: false).loadBanners();
    Provider.of<ProductProvider>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
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

    Navigator.of(context).pushNamed(AppRoutes.SEARCH_PRODUCT, arguments: query);
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final productListProvider = Provider.of<ProductProvider>(context);

    final allProducts = productListProvider.produtos;

    final visibleProducts =
        allProducts.where((item) => item.userId != auth.userId).toList();

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
          Consumer<CartProvider>(
            child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART),
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                )),
            builder: (ctx, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
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
                color: Colors.grey.shade100,
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
                      CategoryRoundels(),
                      ProductGrid(
                        list_products: visibleProducts,
                        quantityGrid: 6,
                        title: "Produtos para você",
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

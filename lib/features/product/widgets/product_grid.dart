import 'package:appshop/core/models/product_model.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/features/product/Provider/product_list_provider.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/widgets/product_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  final title;
  final quantityGrid;

  ProductGrid(this.showFavoriteOnly, this.title, this.quantityGrid);

  @override
  Widget build(BuildContext context) {
    final _userId = Provider.of<AuthProvider>(context).userId;
    final provider = Provider.of<ProductListProvider>(context);

    final List<ProductModel> _loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    final _listProduct =
        _loadedProducts.where((item) => item.userId != _userId).toList();

    final _itensCount = _listProduct.length >= quantityGrid
        ? quantityGrid
        : _listProduct.length;

    if (_listProduct.isEmpty) {
      return Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Text(
            showFavoriteOnly
                ? "Nenhum produto favorito encontrado."
                : "Nenhum produto para venda encontrado.",
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ));
    }

    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(8),
            itemCount: _itensCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (ctx, index) => ChangeNotifierProvider(
              create: (_) => ProductProvider(_listProduct[index]),
              child: ProductGridItem(),
            ),
          ),
        ],
      ),
    );
  }
}

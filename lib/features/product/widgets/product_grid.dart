import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/features/product/Provider/product_list.dart';
import 'package:appshop/features/product/widgets/product_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final _userId = Provider.of<AuthProvider>(context).userId;
    final provider = Provider.of<ProductList>(context);

    final List<ProductProvider> _loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    final _listProduct =
        _loadedProducts.where((item) => item.userId != _userId).toList();

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

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: _listProduct.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: _listProduct[index],
        child: ProductGridItem(),
      ),
    );
  }
}

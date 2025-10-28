import 'package:appshop/components/app_drawer.dart';
import 'package:appshop/components/product_item.dart';
import 'package:appshop/models/product_list.dart';
import 'package:appshop/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList product = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Gerenciar produtos",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM),
            icon: Icon(Icons.add),
          )
        ],
        backgroundColor: Colors.purple,
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: product.itemsCount,
            itemBuilder: (ctx, index) => Column(
              children: [
                ProductItem(product.items[index]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:appshop/components/app_drawer.dart';
import 'package:appshop/components/product_item.dart';
import 'package:appshop/models/auth/auth.dart';
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
    final _userId = Provider.of<Auth>(context).userId;
    final product = Provider.of<ProductList>(context).items;
    final _productList =
        product.where((item) => item.userId == _userId).toList();

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
            itemCount: _productList.length,
            itemBuilder: (ctx, index) => Column(
              children: [
                ProductItem(_productList[index]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

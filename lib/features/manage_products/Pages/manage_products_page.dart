import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/features/manage_products/widgets/manage_product_grid.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:appshop/shared/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userId = Provider.of<AuthProvider>(context).userId;
    final product = Provider.of<ProductProvider>(context).produtos;
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
                Navigator.of(context).pushNamed(AppRoutes.MANAGE_PRODUCT_FORM),
            icon: Icon(Icons.add),
          )
        ],
        backgroundColor: Colors.purple,
      ),
      drawer: AppDrawer(),
      body: Padding(
          padding: EdgeInsets.all(12),
          child: _productList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Você ainda não possui nenhum produto cadastrado.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(AppRoutes.MANAGE_PRODUCT_FORM),
                        child: Text("Cadastre agora",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _productList.length,
                  itemBuilder: (ctx, index) => Column(
                    children: [
                      ManageProductGrid(_productList[index]),
                      Divider(),
                    ],
                  ),
                )),
    );
  }
}

import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/errors/generic_exception.dart';
import 'package:appshop/features/product/Models/product_model.dart';
import 'package:appshop/features/product/Provider/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageProductGrid extends StatelessWidget {
  final ProductModel product;

  ManageProductGrid(this.product);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(product.name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.MANAGE_PRODUCT_FORM,
                  arguments: product,
                );
              },
              icon: Icon(Icons.edit, color: Colors.purple),
            ),
            IconButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Confirmar exclusão"),
                    content: Text("Deseja excluir o produto ${product.name}?"),
                    actions: [
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () => {
                          Navigator.of(ctx).pop(),
                        },
                      ),
                      TextButton(
                        child: Text("Confirmar"),
                        onPressed: () async {
                          try {
                            Navigator.of(ctx).pop();
                            await Provider.of<ProductList>(
                              context,
                              listen: false,
                            ).deleteProduct(product);
                          } on GenericExeption catch (error) {
                            msg.showSnackBar(
                                SnackBar(content: Text(error.toString())));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/models/cart_item_model.dart';
import 'package:appshop/core/models/order.dart';
import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/features/product/Provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListaDeCompras extends StatefulWidget {
  final Order order;

  ListaDeCompras({required this.order});

  @override
  State<ListaDeCompras> createState() => _ListaDeComprasState();
}

class _ListaDeComprasState extends State<ListaDeCompras> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    void _selectPage(BuildContext context, CartItemModel item) {
      final productList =
          Provider.of<ProductProvider>(context, listen: false).produtos;

      final product = productList.where((p) => p.id == item.id).firstOrNull;
      if (product == null) {
        showAppFlushbar(
          context,
          message: "Produto indisponível!",
          type: FlushType.error,
        );
        return;
      }

      Navigator.of(context).pushNamed(
        AppRoutes.DETAILS_PRODUCT,
        arguments: product,
      );
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              DateFormat("dd/MM/yyyy").format(widget.order.date),
            ),
            subtitle: Text(formatPrice(widget.order.total)),
            trailing: IconButton(
                onPressed: () => {
                      setState(() {
                        _expanded = !_expanded;
                      }),
                    },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more)),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: widget.order.products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => _selectPage(context, product),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${product.quantity}x ${formatPrice(product.price)}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < widget.order.products.length - 1) Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

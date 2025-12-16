import 'package:appshop/models/cart_item.dart';
import 'package:appshop/models/order.dart';
import 'package:appshop/models/product_list.dart';
import 'package:appshop/pages/products/product_detail.dart';
import 'package:appshop/utils/flushbar_helper.dart';
import 'package:appshop/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  OrderWidget({required this.order});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    void _selectPage(BuildContext context, CartItem item) {
      final productList =
          Provider.of<ProductList>(context, listen: false).items;

      final product = productList.where((p) => p.id == item.id).firstOrNull;
      if (product == null) {
        showAppFlushbar(
          context,
          message: "Produto indisponível!",
          type: FlushType.error,
        );
        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: product,
            child: ProductDetail(),
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(formatPrice(widget.order.total)),
            subtitle: Text(
              DateFormat("dd/MM/yyyy hh:mm").format(widget.order.date),
            ),
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

import 'package:appshop/shared/Models/order.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaDeCompras extends StatelessWidget {
  final Order order;

  const ListaDeCompras({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final firstProduct = order.products.first;

    final totalItems = order.products.fold(
      0,
      (sum, item) => sum + item.quantity,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.DETALHES_COMPRAS,
          arguments: order,
        );
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(width: 1, color: colorScheme.outline),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pedido realizado",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface),
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat(
                            "dd/MM/yyyy • HH:mm",
                          ).format(order.date),
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurface.withOpacity(0.4),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      title: "Total",
                      value: formatPrice(order.total),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      title: "Itens",
                      value: "$totalItems",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  firstProduct.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (order.products.length > 1)
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "+ ${order.products.length - 1} produto(s)",
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.55),
            ),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

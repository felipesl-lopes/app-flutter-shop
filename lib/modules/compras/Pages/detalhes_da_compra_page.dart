import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/flushbar_helper.dart';
import 'package:appshop/core/utils/formatters.dart';
import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/modules/compras/models/compras_model.dart';
import 'package:appshop/modules/compras/models/order.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetalhesDaCompraPage extends StatelessWidget {
  const DetalhesDaCompraPage({super.key});

  void _openProduct(
    BuildContext context,
    ComprasModel item,
  ) {
    final productList = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).produtos;

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

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    final endereco = order.endereco;

    final totalItems = order.products.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: BackAppBar(
        title: 'Detalhes da compra',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pedido realizado",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat(
                      "dd/MM/yyyy • HH:mm",
                    ).format(order.date),
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailInfo(
                          title: "Total",
                          value: formatPrice(order.total),
                        ),
                      ),
                      Expanded(
                        child: _DetailInfo(
                          title: "Itens",
                          value: "$totalItems",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (endereco != null) ...[
              SizedBox(height: 24),
              Text(
                "Endereço de entrega",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorScheme.surfaceContainerLowest,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${endereco.rua}, ${endereco.numero}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (endereco.complemento.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          endereco.complemento,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      "${endereco.bairro} • ${endereco.cidade}/${endereco.uf}",
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: 4),
                    Text("CEP: ${endereco.cep}",
                        style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
            SizedBox(height: 24),
            Text(
              "Produtos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12),
            ...order.products.map((item) {
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openProduct(context, item),
                child: Container(
                  margin: EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colorScheme.surfaceContainerLowest,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: colorScheme.surface,
                            ),
                            child: Icon(
                              Icons.inventory_2_outlined,
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "${item.quantity}x unidade(s)",
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatPrice(item.price),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatPrice(item.price * item.quantity),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (item.avaliacaoId == null) ...[
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  AppRoutes.AVALIACAO_PRODUTO,
                                  arguments: {
                                    'item': item,
                                    'orderId': order.id
                                  });
                            },
                            child: Text('Avaliar produto'),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DetailInfo extends StatelessWidget {
  final String title;
  final String value;

  const _DetailInfo({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

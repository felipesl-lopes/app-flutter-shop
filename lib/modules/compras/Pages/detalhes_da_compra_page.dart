import 'package:appshop/modules/product/Provider/product_provider.dart';
import 'package:appshop/shared/Models/order.dart';
import 'package:appshop/shared/Widgets/back_app_bar.dart';
import 'package:appshop/shared/constants/app_colors.dart';
import 'package:appshop/shared/constants/app_routes.dart';
import 'package:appshop/shared/utils/flushbar_helper.dart';
import 'package:appshop/shared/utils/formatters.dart';
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
                color: Colors.grey.shade100,
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
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat(
                      "dd/MM/yyyy • HH:mm",
                    ).format(order.date),
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
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${endereco.rua}, ${endereco.numero}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (endereco.complemento.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          endereco.complemento,
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      "${endereco.bairro} • ${endereco.cidade}/${endereco.uf}",
                    ),
                    SizedBox(height: 4),
                    Text("CEP: ${endereco.cep}"),
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
              ),
            ),
            SizedBox(height: 12),
            ...order.products.map((item) {
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openProduct(context, item),
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 14,
                  ),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.primary,
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
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "${item.quantity}x unidade(s)",
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatPrice(
                              item.price,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            formatPrice(
                              item.price * item.quantity,
                            ),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.black.withOpacity(0.55),
          ),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

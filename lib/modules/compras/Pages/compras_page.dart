import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/modules/compras/Widgets/lista_de_compras.dart';
import 'package:appshop/modules/compras/providers/order_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComprasPage extends StatefulWidget {
  @override
  State<ComprasPage> createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderListProvider>().loadOrdersCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderListProvider>();

    return Scaffold(
      appBar: BackAppBar(
        title: "Minhas compras",
      ),
      body: ListenableBuilder(
        listenable: provider.loadOrdersCommand,
        builder: (context, child) {
          final status = provider.loadOrdersCommand.value;

          if (status.isRunning) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (status.isFailure) {
            return Center(
              child: Text('Não foi possível carregar os pedidos.'),
            );
          }

          if (provider.itemsCount == 0) {
            return Center(
              child: Text(
                "Nenhum pedido encontrado.",
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadOrdersCommand.execute();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: provider.itemsCount,
              itemBuilder: (ctx, index) {
                return ListaDeCompras(
                  order: provider.items[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

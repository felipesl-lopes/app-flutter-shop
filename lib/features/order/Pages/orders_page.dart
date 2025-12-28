import 'package:appshop/features/order/Provider/order_list_provider.dart';
import 'package:appshop/features/order/Widgets/order_widget.dart';
import 'package:appshop/shared/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderListProvider>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Meus pedidos",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.purple,
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshOrders(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (snapshot.hasError)
            return Center(
              child: Text("Não foi possível carregar os pedidos."),
            );

          return Consumer<OrderListProvider>(builder: (ctx, orders, child) {
            if (orders.itemsCount == 0) {
              return Center(
                child: Text("Nenhum pedido encontrado."),
              );
            }

            return RefreshIndicator(
              onRefresh: () => _refreshOrders(context),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, index) => OrderWidget(
                  order: orders.items[index],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

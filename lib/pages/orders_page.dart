import 'package:appshop/components/app_drawer.dart';
import 'package:appshop/components/order_widget.dart';
import 'package:appshop/models/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<OrderList>(
              builder: (ctx, orders, child) => RefreshIndicator(
                onRefresh: () => _refreshOrders(context),
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, index) => OrderWidget(
                    order: orders.items[index],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

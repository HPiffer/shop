import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_widget.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Pedidos'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null) {
              return Center(
                child: Text('Ocorreu um erro!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orders, child) {
                  return RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: ListView.builder(
                      itemCount: orders.itemsCount,
                      itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
                    ),
                  );
                },
              );
            }
          },
        )
        // _isLoading
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : RefreshIndicator(
        //         onRefresh: () => _refreshProducts(context),
        //         child: ListView.builder(
        //           itemCount: orders.itemsCount,
        //           itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
        //         ),
        //       ),
        );
  }
}

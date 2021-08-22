import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import '../provider/order.dart' show Orders;
import '../widget/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          builder: (ctx, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (data.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                return ListView.builder(
                  itemBuilder: (ctx, i) {
                    return OrderItems(orderData.order[i]);
                  },
                  itemCount: orderData.order.length,
                );
              });
            }
          },
          future:
              Provider.of<Orders>(context, listen: false).fetchAndGetOrder(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
      {required this.id,
      required this.productId,
      required this.price,
      required this.quantity,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'Are you sure?',
                    style: TextStyle(color: Colors.black),
                  ),
                  content: Text(
                    'Do you want to remove this item',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                  ],
                ));
      },
      onDismissed: (val) {
        // if ( quantity > 1) {
        //   cart.updQuantity(productId, quantity);
        // } else
        cart.removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(
                    price.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              'Total \${${price * quantity}}',
              style: TextStyle(color: Colors.black),
            ),
            trailing: Text(
              '$quantity x',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

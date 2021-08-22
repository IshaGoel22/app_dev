// import 'dart:html';

import 'package:flutter/material.dart';
import '../provider/order.dart' as ci;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItems extends StatefulWidget {
  final ci.OrderItems order;
  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 110, 200)
                : 95,
            child: ListTile(
              title: Text(
                '\$${widget.order.amount}',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(DateFormat.yMMMEd().format(widget.order.dateTime),
                  style: TextStyle(color: Colors.black)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 10, 100)
                : 0,
            child: ListView(
                children: widget.order.products
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.title,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              '\$${e.quantity} x \$${e.price}',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList()),
          )
        ],
      ),
    );
  }
}

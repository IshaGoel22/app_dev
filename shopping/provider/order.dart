import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop_app/provider/cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems(
      {required this.amount,
      required this.dateTime,
      required this.id,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItems> _order = [];
  List<OrderItems> get order {
    return [..._order];
  }

  final String authToken, userId;
  Orders(this.authToken, this.userId, this._order);

  Future<void> fetchAndGetOrder() async {
    final url =
        'https://shop-b3963-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    final List<OrderItems> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItems(
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderId,
          products: (orderData['products'] as List<dynamic>)
              .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity']))
              .toList()));
    });
    _order = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeSpan = DateTime.now();

    notifyListeners();
    final url =
        'https://shop-b3963-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timeSpan.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity,
                    })
                .toList(),
          }));
      _order.insert(
          0,
          OrderItems(
              amount: total,
              dateTime: timeSpan,
              id: json.decode(response.body)['name'],
              products: cartProducts));
    } catch (error) {
      print(error);
    }
  }
}

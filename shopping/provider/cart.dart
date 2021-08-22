import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    // ignore: non_constant_identifier_names
    _items.forEach((key, value) {
      total = value.quantity * value.price;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    // (_items[productId]!.quantity > 1)
    //     ? _items.update(
    //         productId,
    //         (v) => CartItem(
    //             id: v.id,
    //             title: v.title,
    //             price: v.price,
    //             quantity: v.quantity - 1)):
    _items.remove(productId);

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void undo(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (v) => CartItem(
              id: v.id,
              title: v.title,
              price: v.price,
              quantity: v.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}

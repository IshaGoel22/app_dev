import 'dart:convert';
import 'package:http/http.dart' as http;
import 'http_exception.dart';
import 'product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavOnly = false;

  List<Product> get items {
    if (_showFavOnly) {
      return items.where((e) => e.isFavorite).toList();
    } else {
      return [..._items];
    }
  }

  // ignore: unused_field
  String _authToken, userId;
  Products(this._authToken, this.userId, this._items);

  // List<Product> favItems;
  List<Product> get favItems {
    return items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndGetData([bool filterUser = false]) async {
    final filterData =
        filterUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      final response = await http.get(Uri.parse(
          'https://shop-b3963-default-rtdb.firebaseio.com/product.json?auth=$_authToken&$filterData'));
      final List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(json.decode(response.body).toString());

      if (extractedData.isEmpty) {
        print('null');
        return;
      }

      var url =
          'https://shop-b3963-default-rtdb.firebaseio.com//userFavorite/$userId.json?auth=$_authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favData = json.decode(favoriteResponse.body);

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('--$error');
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-b3963-default-rtdb.firebaseio.com/product.json?auth=$_authToken';
    try {
      final value = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title ': product.title,
          'isFavorite': product.isFavorite,
          'description ': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      // print(json.decode(value.body));
      final newProduct = Product(
          id: json.decode(value.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-b3963-default-rtdb.firebaseio.com/product/$id.json?$_authToken';

      await http.patch(Uri.parse(url),
          body: json.encode({
            'title ': newProduct.title,
            'description ': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shop-b3963-default-rtdb.firebaseio.com/product/$id.json?$_authToken';
    var existingProduct;
    existingProduct = _items[_items.indexWhere((element) => element.id == id)];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    // .then((value) {
    if (response.statusCode >= 400) {
      print(response.statusCode);
      _items.insert(
          _items.indexWhere((element) => element.id == id), existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}

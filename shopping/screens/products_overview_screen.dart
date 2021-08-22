import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/provider/products.dart';
import '../provider/cart.dart';
import '../widget/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widget/badge.dart';
import '../widget/product_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFav = false;
  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    //   Future.delayed(Duration.zero).then((value) {
    //     Provider.of<Products>(context).fetchAndGetData().then((_) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //     });
    //   });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false).fetchAndGetData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      // .catchError((error) {
      //   print('error');
      //   showDialog(
      //       context: context,
      //       builder: (ctx) {
      //         return AlertDialog(
      //             title: Text('An error Occured!'),
      //             content: Text(
      //               'Oops something went wrong',
      //               style: TextStyle(color: Colors.black),
      //             ),
      //             actions: <Widget>[
      //               TextButton(
      //                 child: Text('Okay'),
      //                 onPressed: () {
      //                   Navigator.of(ctx).pop();
      //                 },
      //               )
      //             ]);
      //       });
      // });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Shop',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorite) {
                    // productsContainer.showFavOnly();
                    _showOnlyFav = true;
                  } else {
                    // productsContainer.showAll();
                    _showOnlyFav = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text(
                        'Favorites',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: FilterOptions.Favorite,
                    ),
                    PopupMenuItem(
                        child: Text(
                          'Show All',
                          style: TextStyle(color: Colors.black),
                        ),
                        value: FilterOptions.All),
                  ]),
          Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
                // Navigator.of(context).pushReplacement(CustomRoute( builder: (context) => CartScreen(), settings: ,)
              ),
              value: cart.itemCount,
              color: Colors.black),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFav),
    );
  }
}

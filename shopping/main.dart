import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import '../screens/splash_screen.dart';
import '../screens/products_overview_screen.dart';
import '../provider/cart.dart';
import '../provider/order.dart';
import '../provider/products.dart';
import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/order_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/user_products_screen.dart';
// import '../helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (BuildContext context) => Products('', '', []),
              update: (BuildContext context, auth, previous) => Products(
                  auth.token!,
                  auth.userId!,
                  previous == null ? [] : previous.items)),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (BuildContext context) => Orders('', '', []),
              update: (BuildContext context, auth, previous) => Orders(
                  auth.token!,
                  auth.userId!,
                  previous == null ? [] : previous.order)),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                  // pageTransitionsTheme: PageTransitionsTheme(builders: {
                  //   TargetPlatform.android: ,
                  //   TargetPlatform.iOS:,
                  // }),
                  // appBarTheme: AppBarTheme(
                  textTheme: ThemeData.dark().textTheme.copyWith(
                      headline6: TextStyle(fontFamily: 'Anton', fontSize: 22))),
              // ),
              home: auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLoginIn(),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                EditProductScrreen.routeName: (ctx) => EditProductScrreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                '/product-overview': (ctx) => ProductOverviewScreen(),
              }),
        ));
  }
}

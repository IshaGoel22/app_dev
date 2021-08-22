import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widget/app_drawer.dart';
import '../widget/user_product_item.dart';
import '../provider/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user';

  Future<void> _refreshData(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndGetData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScrreen.routeName);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: _refreshData(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => _refreshData(context),
                  child: Consumer<Products>(
                    builder: (ctx, productData, _) => Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: productData.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              UseProductItem(
                                  id: productData.items[index].id,
                                  title: productData.items[index].title,
                                  imageUrl: productData.items[index].imageUrl),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

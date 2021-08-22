import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import './product_items.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final items = showFavs ? productData.favItems : productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: items[i],
              // create: (_) => items[i],
              child: ProductItem(),
            ),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisExtent: 160));
  }
}

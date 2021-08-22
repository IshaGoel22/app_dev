import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UseProductItem extends StatelessWidget {
  final String title, imageUrl, id;
  UseProductItem(
      {required this.id, required this.title, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      leading: CircleAvatar(
        // child: Image.network(imageUrl),
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScrreen.routeName, arguments: id);
                },
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.edit)),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}

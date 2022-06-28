// import 'dart:html';

import 'package:flutter/material.dart';
import '../dummy_data.dart.dart';
import '../widget/category_items.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(10),
      children: 
          buildListTile('Isha Goel(102183055)', Icons.account_circle_outlined, () {
            // Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
          }),
          buildListTile('Akshat Khosla(102053026)', Icons.account_circle_outlined, () {
            //Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
          }),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisExtent: 80,
        mainAxisSpacing: 10,
      ),
    );
  }
}

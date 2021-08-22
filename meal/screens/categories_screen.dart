// import 'dart:html';

import 'package:flutter/material.dart';
import '../dummy_data.dart.dart';
import '../widget/category_items.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(10),
      children: DUMMY_CATEGORIES
          .map((any) => CategortItem(any.id, any.title, any.color))
          .toList(),
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

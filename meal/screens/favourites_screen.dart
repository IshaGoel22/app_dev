import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/meals.dart';
import 'package:flutter_complete_guide/widget/meal_item.dart';

class FavouritesScreen extends StatefulWidget {
  final List<Meal> favouriteMeals;
  // final Function togglefavourie;
  FavouritesScreen(this.favouriteMeals);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return (widget.favouriteMeals.isEmpty)
        ? Center(
            child: Text('You don\'t have any favourites yet..!'),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return MealItem(
                  id: widget.favouriteMeals[index].id,
                  title: widget.favouriteMeals[index].title,
                  imageURL: widget.favouriteMeals[index].imageUrl,
                  affordability: widget.favouriteMeals[index].affordability,
                  complexity: widget.favouriteMeals[index].complexity,
                  duration: widget.favouriteMeals[index].duration);
            },
            itemCount: widget.favouriteMeals.length,
          );
  }
}

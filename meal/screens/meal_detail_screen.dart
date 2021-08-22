// import 'dart:html';

import 'package:flutter/rendering.dart';

import '../dummy_data.dart.dart';

import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  // final String mealId;
  // MealDetailScreen({@required this.mealId});
  final Function togglefav, isfav;
  MealDetailScreen(this.togglefav, this.isfav);

  static const routeName = '/meal';

  Widget buildContainer(Widget any) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10)),
      height: 100,
      width: 300,
      child: any,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((any) {
      return any.id.contains(mealId);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMeal.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 250,
              width: double.infinity,
              child: Image.network(
                selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Ingredients',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            buildContainer(
              ListView.builder(
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    selectedMeal.ingredients[index],
                  ),
                ),
                itemCount: selectedMeal.ingredients.length,
              ),
            ),
            Container(
              child: Text(
                'Recipe',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            buildContainer(ListView.builder(
              itemBuilder: (ctx, index) => Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('#${index + 1}'),
                    ),
                    title: Text(selectedMeal.steps[index]),
                  ),
                  Divider(),
                ],
              ),
              itemCount: selectedMeal.steps.length,
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => togglefav(mealId),
        child: Icon(isfav(mealId) ? Icons.star : Icons.star_border),
      ),
    );
  }
}

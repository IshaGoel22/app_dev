import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/dummy_data.dart.dart';
import 'package:flutter_complete_guide/models/meals.dart';
// import 'package:flutter_complete_guide/screens/favourites_screen.dart';
import '../screens/meal_detail_screen.dart';
import '../screens/fliters_screen.dart';
import '../screens/tabsscreen.dart';
import '../screens/category_meal_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeal = [];
  void _setFilters(Map<String, bool> filterData) {
    _filters = filterData;
    // ignore: missing_return
    availableMeals = DUMMY_MEALS.where((any) {
      if (_filters['gluten'] && !any.isGlutenFree) {
        return false;
      }
      if (_filters['lactose'] && !any.isLactoseFree) {
        return false;
      }
      if (_filters['Vegan'] && !any.isVegan) {
        return false;
      }
      if (_filters['Vegetarian'] && !any.isVegetarian) {
        return false;
      }
      return true;
    }).toList();
  }

  bool isMealFavourite(String id) {
    return _favouriteMeal.any((element) => element.id == id);
  }

  void toggleFavourite(String mealId) {
    final existingIndex =
        _favouriteMeal.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favouriteMeal.remove(existingIndex);
      });
    } else {
      setState(() {
        _favouriteMeal.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
            headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
      home: TabsScreen(_favouriteMeal),
      routes: {
        '/meal': (ctx) => MealDetailScreen(toggleFavourite, isMealFavourite),
        '/tab': (ctx) => TabsScreen(_favouriteMeal),
        '/any': (ctx) => CategoryMealScreen(availableMeals),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
    );
  }
}

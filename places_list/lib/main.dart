import 'package:flutter/material.dart';
import 'package:placesapp/screens/places_detail_screen.dart';
import '../provider/great_places.dart';
import 'package:provider/provider.dart';
import '../screens/add_place_screen.dart';
import '../screens/places_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Great Places',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            accentColor: Colors.amber,
          ),
          home: PlacesListScreen(),
          routes: {
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
            PlacesDetailScreen.routeName: (ctx) => PlacesDetailScreen(),
          }),
    );
  }
}

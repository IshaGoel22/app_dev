import 'package:flutter/material.dart';
import 'package:placesapp/screens/places_detail_screen.dart';
import 'package:provider/provider.dart';
import './add_place_screen.dart';
import '../provider/great_places.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Places'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
                },
                child: Icon(Icons.add),
                style: TextButton.styleFrom(primary: Colors.white)),
          ],
        ),
        body: FutureBuilder(
          future:
              Provider.of<GreatPlaces>(context, listen: false).fetchAndGetDta(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<GreatPlaces>(
                  builder: (ctx, greatPlaces, _) => (greatPlaces.items.length <=
                          0)
                      ? Center(
                          child: Text('No Places added yet'),
                        )
                      : ListView.builder(
                          itemCount: greatPlaces.items.length,
                          itemBuilder: (ctx, i) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                    greatPlaces.items[i].image,
                                  ),
                                ),
                                title: Text(greatPlaces.items[i].title),
                                subtitle:
                                    Text(greatPlaces.items[i].location.address),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      PlacesDetailScreen.routeName,
                                      arguments: greatPlaces.items[i].id);
                                },
                              )),
                ),
        ));
  }
}

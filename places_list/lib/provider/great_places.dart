import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:placesapp/helper/dbhelper.dart';
import 'package:placesapp/helper/location_helper.dart';
import 'package:placesapp/model/places.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findBy(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(
      File pickedImage, String text, PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );
    // ignore: unused_local_variable
    final updLoc = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);
    final newPlace = Place(
      location: pickedLocation,
      id: DateTime.now().toString(),
      title: text,
      image: pickedImage,
    );
    _items.add(newPlace);
    notifyListeners();
    //places-->name given to table
    //keys passed to map should be same as written in table
    //we store path in database
    DbHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndGetDta() async {
    final dataList = await DbHelper.getData('user_places');
    _items = dataList
        .map(
          (e) => Place(
            location: PlaceLocation(
                latitude: e['loc_lat'],
                longitude: e['loc_lng'],
                address: e['address']),
            id: e['id'],
            image: File(e['image']),
            title: e['title'],
          ),
        )
        .toList();
    notifyListeners();
  }
}

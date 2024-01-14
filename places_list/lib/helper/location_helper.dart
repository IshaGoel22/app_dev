import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter/material.dart';

const GOOGLE_API_KEY = 'AIzaSyB9t1uzSUoIdnxs-C9TZJyh1hWIPM9ZP_w';

class LocationHelper {
  static String generateLocImage(
      {required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
    //Google map static api -->gives image of map location
  }

//geocoding helps to transfer adress to cordinated i.e. translating a human-readable address into a location on a map
//reverse geocoding is viceversa
  static Future<String> getPlaceAddress(double lat, double lng) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}

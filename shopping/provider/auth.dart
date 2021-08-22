import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider/http_exception.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? _token;
  Timer? _authTimer;
  DateTime _expireyDate = DateTime.now();
  // ignore: unused_field
  String? _userId;
  String? get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expireyDate.toString().isNotEmpty &&
        _expireyDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null.toString();
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB2TZ2N6gndX3WY9FjeNmoi9w6rxMQnmTc';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireyDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireyDate.toIso8601String(),
      });
      pref.setString(
          'userData', userData); //to store on device storage as string
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLoginIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userId')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.get('userData').toString()) as Map<String, String>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']!);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expireyDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null.toString();
    _userId = null.toString();
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    _expireyDate = DateTime.parse(null.toString());
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timediff = _expireyDate.difference(DateTime.now()).inSeconds;
    final timer = Timer(Duration(seconds: timediff), logout);
    print(timer);
  }
}

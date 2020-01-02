import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class SharedPrefs {
  static final SharedPrefs _sharedPrefs = new SharedPrefs._internal();

  SharedPreferences _prefs;
  String _token;
  bool isLogedin = false;

  SharedPrefs._internal() {
    initInstance();
  }

  factory SharedPrefs() {
    return _sharedPrefs;
  }

  Stream<SharedPreferences> initInstance() {
    return Stream.fromFuture(SharedPreferences.getInstance())
        .map((shp) => initSharedPreferences(shp));
  }

  initSharedPreferences(SharedPreferences shp) {
    _prefs = shp;
  }
  
}

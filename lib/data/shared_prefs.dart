import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _sharedPrefs = new SharedPrefs._internal();
  String _LOGIN = "isLogin";
  SharedPreferences _prefs;

  SharedPrefs._internal() {
    initInstance();
  }

  factory SharedPrefs() {
    return _sharedPrefs;
  }

  Stream<SharedPreferences> initInstance() {
    return Stream.fromFuture(SharedPreferences.getInstance())
        .share()
        .map((shp) => initSharedPreferences(shp));
  }

  initSharedPreferences(SharedPreferences shp) {
    _prefs = shp;
  }

  Stream<bool> isLogin() {
    return Stream.value(_prefs.getBool(_LOGIN))
        .map((bool) => getFalseOnNull(bool));
  }

  Stream<bool> setLogin(bool login) {
    return Stream.fromFuture(_prefs.setBool(_LOGIN, login));
  }

  getFalseOnNull(bool boolean) {
    return boolean == null ? false : boolean;
  }
}

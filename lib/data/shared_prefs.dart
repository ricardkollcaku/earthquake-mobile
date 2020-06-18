import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _sharedPrefs = new SharedPrefs._internal();
  String _LOGIN = "isLogin";
  String _TOKEN = "token";
  String _USER = "user";

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
    return Stream.fromFuture(_prefs.setBool(_LOGIN, login))
        .where((isSaved) => (isSaved))
        .map((isSaved) => login);
  }

  getFalseOnNull(bool boolean) {
    return boolean == null ? false : boolean;
  }

  Stream<String> getToken() {
    return Stream.value(_prefs.getString(_TOKEN))
        .flatMap((bool) => getStringOrEmpty(bool));
  }

  Stream<bool> removeToken() {
    return Stream.fromFuture(_prefs.remove(_TOKEN))
        .where((isSaved) => (isSaved));
  }

  Stream<String> setToken(String token) {
    return Stream.fromFuture(_prefs.setString(_TOKEN, token))
        .where((isSaved) => (isSaved))
        .map((isSaved) => token);
  }

  Stream<String> getStringOrEmpty(String string) {
    return string == null ? Stream.empty() : Stream.value(string);
  }

  Stream<String> setUser(String user) {
    return Stream.fromFuture(_prefs.setString(_USER, user))
        .where((isSaved) => (isSaved))
        .map((isSaved) => user);
  }

  Stream<String> getUser() {
    return Stream.value(_prefs.getString(_USER))
        .flatMap((bool) => getStringOrEmpty(bool));
  }
}

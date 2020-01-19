import 'dart:convert';

import 'package:earthquake/data/model/token.dart';
import 'package:earthquake/data/model/user.dart';
import 'package:earthquake/data/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  SharedPrefs _sharedPrefs;

  SharedPrefsService() {
    _sharedPrefs = new SharedPrefs();
  }

  Stream<SharedPreferences> initLocalSharedPref() {
    return _sharedPrefs.initInstance();
  }

  Stream<bool> isLogin() {
    return _sharedPrefs.isLogin();
  }

  Stream<bool> setLogin(bool login) {
    return _sharedPrefs.setLogin(login);
  }

  Stream<String> setToken(Token token) {
    return _sharedPrefs.setToken(token.token);
  }

  Stream<String> getToken(){
    return _sharedPrefs.getToken();
  }

  Stream<User> setUser(User user) {
    return _sharedPrefs
        .setUser(json.encode(user.toJson()))
        .map((s) => user);
  }

  Stream<User> getUser() {
    return _sharedPrefs.getUser()
        .map((s) => User.fromJson(json.decode(s)));
  }


  Stream<bool> removeToken() {
    return _sharedPrefs.removeToken();
  }
}

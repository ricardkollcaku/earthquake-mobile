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
}

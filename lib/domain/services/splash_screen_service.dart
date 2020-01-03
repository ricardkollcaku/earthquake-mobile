import 'package:earthquake/domain/services/shared_prefs_service.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenService {
  SharedPrefsService _sharedPrefsService;
  UserService _userService;

  SplashScreenService() {
    _sharedPrefsService = new SharedPrefsService();
    _userService = new UserService();
  }

  Stream<SharedPreferences> initLocalSharedPrefs() {
    return _sharedPrefsService.initLocalSharedPref();
  }

  Stream<bool> isLogin() {
    return _userService.isLogIn();
  }
}

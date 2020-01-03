import 'package:earthquake/domain/services/shared_prefs_service.dart';

class UserService {
  SharedPrefsService _sharedPrefsService;

  UserService() {
    _sharedPrefsService = new SharedPrefsService();
  }

  Stream<bool> isLogIn() {
    return _sharedPrefsService.isLogin();
  }

  Stream<bool> setLogin(bool login) {
    return _sharedPrefsService.setLogin(login);
  }
}

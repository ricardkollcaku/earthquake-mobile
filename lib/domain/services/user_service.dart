import 'package:earthquake/domain/services/shared_prefs_service.dart';
import 'package:rxdart/rxdart.dart';
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

  Stream<bool> logout() {
    return _sharedPrefsService
        .removeToken()
        .flatMap((isRemoved) => _sharedPrefsService.setLogin(false));
  }
}

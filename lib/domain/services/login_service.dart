import 'package:earthquake/data/model/login.dart';
import 'package:earthquake/domain/services/api_service.dart';
import 'package:earthquake/domain/services/shared_prefs_service.dart';
import 'package:rxdart/rxdart.dart';

class LoginService {
  SharedPrefsService _sharedPrefsService;
  ApiService _apiService;

  LoginService() {
    _sharedPrefsService = new SharedPrefsService();
    _apiService = new ApiService();
  }

  Stream<bool> login(Login login) {
  return _apiService.login(login)
        .flatMap((token) => _sharedPrefsService.setToken(token))
        .map((token) => true)
        .switchIfEmpty(Stream.value(false))
        .flatMap((isLogin) => _sharedPrefsService.setLogin(isLogin));
  }
}

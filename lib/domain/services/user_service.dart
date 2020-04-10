import 'package:earthquake/data/model/change_password.dart';
import 'package:earthquake/data/model/login.dart';
import 'package:earthquake/data/model/register.dart';
import 'package:earthquake/data/model/user.dart';
import 'package:earthquake/domain/services/shared_prefs_service.dart';
import 'package:rxdart/rxdart.dart';

import 'api_service.dart';
class UserService {
  SharedPrefsService _sharedPrefsService;
  ApiService _apiService;
  static User user;


  UserService() {
    _sharedPrefsService = new SharedPrefsService();
    _apiService = new ApiService();
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

  Stream<bool> login(Login login) {
    return _apiService.login(login)
        .flatMap((token) => _sharedPrefsService.setToken(token))
        .map((token) => true)
        .switchIfEmpty(Stream.value(false))
        .flatMap((isLogin) => _sharedPrefsService.setLogin(isLogin));
  }

  Stream<bool> register(Register register) {
    return _apiService.register(register)
        .flatMap((token) => _sharedPrefsService.setToken(token))
        .map((token) => true)
        .switchIfEmpty(Stream.value(false))
        .flatMap((isLogin) => _sharedPrefsService.setLogin(isLogin));
  }

  forgotPassword(String email) {
    return _apiService.forgotPassword(email);
  }

  changePassword(ChangePassword changePassword) {
    return _apiService.changePassword(changePassword);
  }

  Stream<User> getUser() {
    return _sharedPrefsService.getUser();
  }

  Stream<User> setNotificationToUser(User user) {
    return _apiService
        .changeNotification(user)
        .flatMap((user) => setUser(user));
  }

  Stream<User> setUser(User user) {
    return _sharedPrefsService.setUser(user);
  }


  Stream<String> setFirebaseToken(String token){
    print(token);
    return _apiService.setFirebaseToken(token);
  }

}

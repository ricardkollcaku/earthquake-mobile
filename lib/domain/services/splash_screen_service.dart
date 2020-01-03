import 'package:device_info/device_info.dart';
import 'package:earthquake/domain/services/api_service.dart';
import 'package:earthquake/domain/services/shared_prefs_service.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenService {
  SharedPrefsService _sharedPrefsService;
  UserService _userService;
  DeviceInfoPlugin _deviceInfo;
  ApiService _apiService;

  SplashScreenService() {
    _sharedPrefsService = new SharedPrefsService();
    _userService = new UserService();
    _deviceInfo = new DeviceInfoPlugin();
    _apiService = new ApiService();
  }

  Stream<SharedPreferences> initLocalSharedPrefs() {
    return _sharedPrefsService.initLocalSharedPref();
  }

  Stream<bool> isLogin() {
    return _userService.isLogIn();
  }

  Stream<String> serverHeartBeat() {
    return Rx.concat([getIosCode(), getAndroidCode()])
        .flatMap((s) => _apiService.heartBeat(s));
  }

  Stream<String> getAndroidCode() {
    return Stream.fromFuture(_deviceInfo.androidInfo)
        .map((android) => android.androidId)
        .onErrorResume((th) => Stream.empty());
  }

  Stream<String> getIosCode() {
    return Stream.fromFuture(_deviceInfo.iosInfo)
        .map((ios) => ios.toString())
        .onErrorResume((th) => Stream.empty());
  }
}

import 'package:earthquake/domain/services/splash_screen_service.dart';
import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:earthquake/presantation/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_helper.dart';
import 'main_non_login_activity.dart';

class SplashScreenActivity extends StatelessWidget {
  static const String tag = 'splash-screen-page';
  SplashScreenService _screenService;
  BuildContext _buildContext;

  SplashScreenActivity() {
    _screenService = new SplashScreenService();
    initApp();

  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        UiHelper.setCurrentScaffoldContext(context);
        return Center(child: Text("SplashScreenActivity"),);
      }),
    );
  }

  void initApp() {
    _screenService
        .initLocalSharedPrefs()
        .map((t) => initUtils(t))
        .flatMap((shp) => _screenService.serverHeartBeat())
        .flatMap((shp) => _screenService.isLogin())
        .flatMap((isLogin) =>
    isLogin ?
    _screenService.saveCurrentUserOnShp(isLogin) :
    Stream.value(false))
        .map((bool) => redirectToActivity(bool))
        .listen(onData);
  }

  redirectToActivity(bool isLogin) {
    if (isLogin)
      Navigator.of(_buildContext)
          .pushReplacementNamed(MainLoginActivity.tag);
    else
      Navigator.of(_buildContext)
          .pushReplacementNamed(MainNonLoginActivity.tag);
  }

  void onData(event) {}

  SharedPreferences initUtils(SharedPreferences t) {
    MapProvider.initMapProvider();
    return t;
  }


}

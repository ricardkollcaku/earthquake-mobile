import 'package:earthquake/domain/services/splash_screen_service.dart';
import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'main_non_login_activity.dart';

class SplashScreenActivity extends StatelessWidget {
  static const String tag = 'splash-screen-page';
  SplashScreenService _screenService;
  BuildContext _buildContext;

  SplashScreenActivity() {
    _screenService = new SplashScreenService();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    initApp();
    return Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }

  void initApp() {
    _screenService
        .initLocalSharedPrefs()
        .flatMap((shp) => _screenService.isLogin())
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
}

import 'package:earthquake/domain/services/splash_screen_service.dart';
import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:earthquake/presantation/activity/splash_screen_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:earthquake/presantation/my_icons.dart';
import 'package:earthquake/presantation/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_helper.dart';

class SplashScreenState extends State<SplashScreenActivity> {
  SplashScreenService _screenService;
  BuildContext _buildContext;
  Widget _myState;
  Color _backGround;

  SplashScreenState() {
    _screenService = new SplashScreenService();
    initApp();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
      backgroundColor: _backGround,
      body: Builder(builder: (BuildContext context) {
        UiHelper.setCurrentScaffoldContext(context);
        return _myState;
      }),
    );
  }

  void initApp() {
    initWidget();
    _backGround = MyColors.accent;
    _screenService
        .initLocalSharedPrefs()
        .map((t) => initUtils(t))
        .flatMap((shp) => serverHartBeat())
        .flatMap((shp) => _screenService.isLogin())
        .flatMap(
            (isLogin) => isLogin ? doOnLogin(isLogin) : doOnNotLogin(isLogin))
        .map((bool) => redirectToActivity(bool))
        .onErrorResume((e) => onError(e))
        .listen(onData);
  }

  Stream<bool> doOnLogin(bool isLogin) {
    return _screenService
        .saveCurrentUserOnShp(isLogin)
        .flatMap((bool) => registerFirebaseToken(bool));
  }

  Stream<String> serverHartBeat() {
    return _screenService.serverHeartBeat().onErrorResume(onNoInternet);
  }

  Stream<bool> doOnNotLogin(bool isLogin) {
    return Stream.value(false);
  }

  bool redirectToActivity(bool isLogin) {
    if (isLogin)
      Navigator.of(_buildContext).pushReplacementNamed(MainLoginActivity.tag);
    else
      Navigator.of(_buildContext)
          .pushReplacementNamed(MainNonLoginActivity.tag);
    return isLogin;
  }

  void onData(event) {}

  SharedPreferences initUtils(SharedPreferences t) {
    MapProvider.initMapProvider();
    return t;
  }

  Stream<bool> onError(e) {
    if (e == 401)
      return _screenService
          .logoutUser()
          .map((bool) => redirectToActivity(bool));
    return Stream.empty();
  }

  Stream<bool> registerFirebaseToken(bool b) {
    return _screenService.registerFirebaseToken().map((s) => b);
  }

  void initWidget() {
    _myState = Center(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 150, left: 100, right: 100),
            child: Image.asset(MyIcons.SC),
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Stream<String> onNoInternet(error) {
    print('testado');
    setState(() {
      _backGround = MyColors.error;
      _myState = Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 150, left: 100, right: 100),
              child: Image.asset(MyIcons.NO_INTERNET),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "Could not connect to server \n Please check your connection or try again later ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      );
    });
    return Stream.empty();
  }
}

import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:earthquake/presantation/activity/splash_screen_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

void main() {
  Stetho.initialize();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          accentColor: MyColors.accent,
          fontFamily: 'Roboto',
          backgroundColor: MyColors.background,
          scaffoldBackgroundColor: MyColors.background,
          appBarTheme: AppBarTheme(
              color: MyColors.white,
              iconTheme: IconThemeData(color: MyColors.actionBarTextColor),
              textTheme: TextTheme(
                  title: TextStyle(
                      color: MyColors.actionBarTextColor, fontSize: 20))),
          textTheme: TextTheme(
              body1: TextStyle(fontSize: 12, color: MyColors.primaryText),
              body2: TextStyle(fontSize: 12, color: MyColors.primaryText),
              title:
              TextStyle(fontSize: 24, color: MyColors.actionBarTextColor))),
      home: SplashScreenActivity(),
      onGenerateRoute: onGeneratedRoutes,
    );
  }

  Route onGeneratedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreenActivity.tag:
        return MaterialPageRoute(
          builder: (context) {
            return SplashScreenActivity();
          },
        );

      case MainNonLoginActivity.tag:
        return MaterialPageRoute(
          builder: (context) {
            return MainNonLoginActivity();
          },
        );

      case MainLoginActivity.tag:
        return MaterialPageRoute(
          builder: (context) {
            return MainLoginActivity();
          },
        );
    }
  }
}

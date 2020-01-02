import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const String tag = 'splash-screen-page';

  @override
  Widget build(BuildContext context) {
    initApp();
    return Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }

  void initApp() {
    
  }
}

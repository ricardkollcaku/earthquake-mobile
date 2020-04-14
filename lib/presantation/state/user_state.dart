import 'package:earthquake/presantation/fragment/login_fragment.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:earthquake/presantation/sheet/forgot_password_sheet.dart';
import 'package:earthquake/presantation/sheet/login_sheet.dart';
import 'package:earthquake/presantation/sheet/register_sheet.dart';
import 'package:flutter/material.dart';

class UserState extends State<LoginFragment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color primary;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    primary = MyColors.accent;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: primary,
        body: Column(
          children: <Widget>[
            logo(),
            Padding(
              child: Container(
                child: _button("LOGIN", primary, Colors.white, Colors.white,
                    primary, _loginSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 80, left: 20, right: 20),
            ),
            Padding(
              child: Container(
                child: _button("REGISTER", primary, Colors.white, Colors.white,
                    primary, _registerSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Padding(
              child: Container(
                child: _button("FORGOT PASSWORD", primary, Colors.white,
                    Colors.white, primary, _forgotPassword),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  }

  _loginSheet() {
    LoginSheet loginSheet = new LoginSheet(context);
    loginSheet.loginSheet(_scaffoldKey);
  }

  _registerSheet() {
    RegisterSheet registerSheet = new RegisterSheet(context);
    registerSheet.registerSheet(_scaffoldKey);
  }

  _forgotPassword() {
    ForgotPasswordSheet forgotPasswordSheet = new ForgotPasswordSheet(context);
    forgotPasswordSheet.forgotPasswordSheet(_scaffoldKey);
  }

  Widget logo() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Container(
              child: Align(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  width: 150,
                  height: 150,
                ),
              ),
              height: 154,
            )),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(bottom: 90, right: 20),
                child: Text(
                  "EARTH",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              child: Align(
                child: Container(
                  padding: EdgeInsets.only(top: 0, left: 10),
                  width: 130,
                  child: Text(
                    "QUAKE",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.width * 0.15,
              bottom: MediaQuery.of(context).size.height * 0.046,
              right: MediaQuery.of(context).size.width * 0.22,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.width * 0.08,
              bottom: 0,
              right: MediaQuery.of(context).size.width * 0.32,
              child: Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textColor, fontSize: 14),
      ),
      onPressed: () {
        function();
      },
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

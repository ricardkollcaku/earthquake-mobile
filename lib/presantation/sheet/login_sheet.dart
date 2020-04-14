import 'package:earthquake/data/model/login.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/splash_screen_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:earthquake/presantation/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginSheet {
  Login _login;
  UserService _userService;
  BuildContext context;
  final _formKey = GlobalKey<FormState>();
  Color primary;

  LoginSheet(BuildContext buildContext) {
    initVariables();
    context = buildContext;
    primary = MyColors.accent;
  }

  void initVariables() {
    _login = Login();
    _userService = new UserService();
  }

  void loginSheet(GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(color: primary),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
          child: Form(
            key: _formKey,
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _formKey.currentState.reset();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: primary,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: Align(
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: primary),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 60),
                          child: UiHelper.getHintedTextFormField(
                              "Email",
                              false,
                              setEmail,
                              Icons.person,
                              getEmailValidator,
                              primary),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: UiHelper.getHintedTextFormField(
                              "Password",
                              true,
                              setPassword,
                              Icons.vpn_key,
                              getPasswordValidator,
                              primary),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            child: UiHelper.button("LOGIN", Colors.white,
                                primary, primary, Colors.white, login),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.2,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  String getEmailValidator(String email) {
    if (!Util.validateEmail(email)) return "Email is not valid";
    return null;
  }

  String getPasswordValidator(String s) {
    if (!Util.getStringLengthValidator(s, 6))
      return "Password should be greater than 5 char";
    return null;
  }

  void setEmail(String email) {
    _login.email = email;
  }

  void setPassword(String password) {
    _login.password = password;
  }

  void login() {
    Stream.value(_formKey.currentState.validate())
        .where((b) => b)
        .map((b) => fillLoginObject(b))
        .flatMap((login) => _userService.login(login))
        .where((isLogin) => isLogin)
        .map((isLogin) => navigateHome())
        .listen(onData);
  }

  void onData(event) {}

  Login fillLoginObject(bool b) {
    _formKey.currentState.save();
    return _login;
  }

  navigateHome() {
    Navigator.of(context).pushReplacementNamed(SplashScreenActivity.tag);
  }
}

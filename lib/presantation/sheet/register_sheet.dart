import 'package:earthquake/data/model/register.dart';
import 'package:earthquake/domain/services/firebase_service.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class RegisterSheet {
  final _formKey = GlobalKey<FormState>();
  Register _register;
  UserService _userService;
  FirebaseService _firebaseService;
  BuildContext context;
  Color primary;

  RegisterSheet(BuildContext buildContext) {
    initFields();
    context = buildContext;

    primary = MyColors.accent;
  }

  void registerSheet(GlobalKey<ScaffoldState> _scaffoldKey) {
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
                                  padding:
                                      EdgeInsets.only(bottom: 25, right: 42),
                                  child: Text(
                                    "REGI",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Align(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 40, left: 28),
                                    width: 130,
                                    child: Text(
                                      "STER",
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
                              "Firstname",
                              false,
                              setFirstName,
                              Icons.person,
                              getFirstNameValidator,
                              primary),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: UiHelper.getHintedTextFormField(
                              "Lastname",
                              false,
                              setLastName,
                              Icons.person,
                              getLastNameValidator,
                              primary),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: UiHelper.getHintedTextFormField(
                              "Email",
                              false,
                              setEmail,
                              Icons.email,
                              getEmailValidator,
                              primary),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: UiHelper.getHintedTextFormField(
                              "Password",
                              true,
                              setPassword,
                              Icons.security,
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
                            child: UiHelper.button("REGISTER", Colors.white,
                                primary, primary, Colors.white, register),
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

  void initFields() {
    _register = new Register();
    _userService = new UserService();
    _firebaseService = new FirebaseService();
  }

  setEmail(String s) {
    _register.email = s;
  }

  setFirstName(String s) {
    _register.firstName = s;
  }

  setLastName(String s) {
    _register.lastName = s;
  }

  setPassword(String s) {
    _register.password = s;
  }

  String getFirstNameValidator(String s) {
    if (!Util.getStringLengthValidator(s, 3))
      return "Firstname should be greater than 2 char";
    return null;
  }

  String getLastNameValidator(String s) {
    if (!Util.getStringLengthValidator(s, 3))
      return "Lastname should be greater than 2 char";
    return null;
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

  void register() {
    Stream.value(_formKey.currentState.validate())
        .where((b) => b)
        .map((b) => fillRegisterObject(b))
        .flatMap((register) => _userService.register(register))
        .where((isLogin) => isLogin)
        .flatMap(
            (isLogin) => _firebaseService.registerToken().map((s) => isLogin))
        .map((isLogin) => navigateHome())
        .listen(onData);
  }

  navigateHome() {
    Navigator.of(context).pushReplacementNamed(MainLoginActivity.tag);
  }

  Register fillRegisterObject(bool b) {
    _formKey.currentState.save();
    return _register;
  }

  void onData(event) {}

  void guestRegister() {
    String guestId = DateTime.now().millisecondsSinceEpoch.toString();
    _register.email = "Guest" + guestId + "@guest.com";
    _register.firstName = "Guest";
    _register.lastName = guestId;
    _register.password = guestId + "!";

    _userService
        .register(_register)
        .where((isLogin) => isLogin)
        .flatMap(
            (isLogin) => _firebaseService.registerToken().map((s) => isLogin))
        .map((isLogin) => navigateHome())
        .listen(onData);
  }
}

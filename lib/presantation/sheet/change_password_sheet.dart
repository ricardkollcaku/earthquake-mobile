import 'package:earthquake/data/model/change_password.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../ui_helper.dart';

class ChangePasswordSheet {
  BuildContext _buildContext;
  ChangePassword _changePassword;
  final _formKey = GlobalKey<FormState>();
  UserService _userService;

  ChangePasswordSheet(BuildContext context) {
    _buildContext = context;
    initFields();
  }

  void changePasswordSheet(GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.transparent),
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
                              color: MyColors.accent,
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
                                        shape: BoxShape.circle,
                                        color: MyColors.accent),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              Positioned(
                                child: Container(
                                  padding:
                                      EdgeInsets.only(bottom: 25, right: 30),
                                  child: Text(
                                    "CHANGE",
                                    style: TextStyle(
                                      fontSize: 26,
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
                                    padding: EdgeInsets.only(top: 40, left: 20),
                                    width: 130,
                                    child: Text(
                                      "PASSWORD",
                                      style: TextStyle(
                                        fontSize: 20,
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
                              "Old Password",
                              true,
                              setOldPassword,
                              Icons.lock,
                              getOldPasswordValidator,
                              MyColors.accent),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: UiHelper.getHintedTextFormField(
                              "New Password",
                              true,
                              setNewPassword,
                              Icons.lock,
                              getPasswordValidator,
                              MyColors.accent),
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
                            child: UiHelper.button(
                                "FORGOT PASSWORD",
                                Colors.white,
                                MyColors.accent,
                                MyColors.accent,
                                Colors.white,
                                changePassword),
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

  void changePassword() {
    UiHelper.setCurrentScaffoldContext(_buildContext);
    Stream.value(_formKey.currentState.validate())
        .where((b) => b)
        .map((b) => saveState(b))
        .flatMap(
            (changePassword) => _userService.changePassword(changePassword))
        .flatMap((user) => _userService.logout())
        .onErrorResume(onError)
        .listen(onSuccess);
  }

  void initFields() {
    _userService = new UserService();
    _changePassword = new ChangePassword();
  }

  ChangePassword saveState(bool b) {
    _formKey.currentState.save();
    return _changePassword;
  }

  onSuccess(bool user) {
    Navigator.of(_buildContext).pushReplacementNamed(MainNonLoginActivity.tag);
  }

  setOldPassword(String password) {
    _changePassword.oldPassword = password;
  }

  setNewPassword(String password) {
    _changePassword.newPassword = password;
  }

  String getPasswordValidator(String s) {
    if (!Util.getStringLengthValidator(s, 6))
      return "Password should be greater than 5 char";
    return null;
  }

  bool oldPassIsWrong = false;
  String serverErrorSms = null;

  String getOldPasswordValidator(String s) {
    if (!Util.getStringLengthValidator(s, 6))
      return "Password should be greater than 5 char";
    if (oldPassIsWrong) return serverErrorSms;
    return null;
  }

  Stream<bool> onError(error) {
    oldPassIsWrong = true;
    serverErrorSms = error;
    _formKey.currentState.validate();
    oldPassIsWrong = false;
    serverErrorSms = null;

    return Stream.empty();
  }
}

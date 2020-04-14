import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class ForgotPasswordSheet {
  BuildContext context;
  String _email;
  final _formKey = GlobalKey<FormState>();
  UserService _userService;
  Color primary;

  ForgotPasswordSheet(BuildContext buildContext) {
    initFields();
    context = buildContext;
    primary = MyColors.accent;
  }

  void forgotPasswordSheet(GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext c) {
      context = c;
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
                                      EdgeInsets.only(bottom: 25, right: 30),
                                  child: Text(
                                    "FORGOT",
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
                              "Email",
                              false,
                              setEmail,
                              Icons.person,
                              getEmailValidator,
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
                            child: UiHelper.button(
                                "FORGOT PASSWORD",
                                Colors.white,
                                primary,
                                primary,
                                Colors.white,
                                forgotPassword),
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

  void forgotPassword() {
    //  UiHelper.setCurrentScaffoldContext(context);
    Stream.value(_formKey.currentState.validate())
        .where((b) => b)
        .map((b) => fillEmail(b))
        .flatMap((email) => _userService.forgotPassword(email))
        .listen(showSms);
  }

  void initFields() {
    _userService = new UserService();
    _email = "";
  }

  String fillEmail(bool b) {
    _formKey.currentState.save();
    return _email;
  }

  String showSms(sms) {
    UiHelper.showError(sms);
    return sms;
  }

  setEmail(String email) {
    _email = email;
  }

  Widget getLogo() {
    return Container();
  }

  String getEmailValidator(String email) {
    if (!Util.validateEmail(email)) return "Email is not valid";
    return null;
  }
}

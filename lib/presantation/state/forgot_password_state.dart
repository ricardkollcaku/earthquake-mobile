import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/forgot_password_activity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class ForgotPasswordState extends State<ForgotPasswordActivity> {
  BuildContext _buildContext;
  String _email;
  final _formKey = GlobalKey<FormState>();
  UserService _userService;


  ForgotPasswordState() {
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Forgot Password'),
        ),
        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
          UiHelper.setCurrentScaffoldContext(_buildContext);
          return Form(key: _formKey,
            child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                getLogo(),
                SizedBox(height: 48.0),
                getHintedTextFormField(
                    "Email", false, setEmail, Icons.person, getEmailValidator),
                SizedBox(height: 24.0),
                getForgotPasswordButton(),
              ],
            ),
            ),);
        }));
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

  Widget getHintedTextFormField(String hint, bool obscure, Function onSaved,
      IconData icon, Function(String) validator) {
    return new TextFormField(
      validator: validator,
      onSaved: onSaved,
      autofocus: false,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }


  Widget getForgotPasswordButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: forgotPassword,
        padding: EdgeInsets.all(12),
        color: MyColors.accent,
        child: Text('Forgot Password', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void forgotPassword() {
    UiHelper.setCurrentScaffoldContext(_buildContext);
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

}

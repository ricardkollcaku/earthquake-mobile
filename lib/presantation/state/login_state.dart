import 'package:earthquake/data/model/login.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/forgot_password_activity.dart';
import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:earthquake/presantation/activity/register_activity.dart';
import 'package:earthquake/presantation/fragment/login_fragment.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';

class LoginState extends State<LoginFragment> {
  Login _login;
  UserService _userService;
  final _formKey = GlobalKey<FormState>();
  LoginState() {
    initVariables();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(key: _formKey, child: Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          getLogo(),
          SizedBox(height: 48.0),
          getHintedTextFormField(
              "Email", false, setEmail, Icons.person, getEmailValidator),
          SizedBox(height: 8.0),
          getHintedTextFormField("Password", true, setPassword, Icons.vpn_key,
              getPasswordValidator),
          SizedBox(height: 24.0),
          getLoginButton(),
          getForgotLabel(),
          getRegisterLabel(),
        ],
      ),
    ),);
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

  void initVariables() {
    _login = Login();
    _userService = new UserService();
  }

  Widget getLogo() {
    return Container();
  }

  Widget getLoginButton() {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: login,
        padding: EdgeInsets.all(12),
        color: MyColors.accent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget getForgotLabel() {
    return new FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: MyColors.primaryText),
      ),
      onPressed: () {
        Navigator.pushNamed(context, ForgotPasswordActivity.tag);
      },
    );
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

  void onData(event) {
  }

  navigateHome() {
    Navigator.of(context)
        .pushReplacementNamed(MainLoginActivity.tag);
  }

  getRegisterLabel() {
    return new FlatButton(
      child: Text(
        'Register now.',
        style: TextStyle(color: MyColors.primaryText),
      ),
      onPressed: () {
        Navigator.pushNamed(context, RegisterActivity.tag);
      },
    );
  }

  Login fillLoginObject(bool b) {
    _formKey.currentState.save();
    return _login;
  }
}

import 'package:earthquake/data/model/register.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:earthquake/presantation/activity/register_activity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class RegisterState extends State<RegisterActivity> {
  BuildContext _buildContext;
  final _formKey = GlobalKey<FormState>();
  Register _register;
  UserService _userService;

  RegisterState() {
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Registor'),
        ),
        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
          UiHelper.setCurrentScaffoldContext(_buildContext);
          return Form(
            key: _formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  getLogo(),
                  SizedBox(height: 48.0),
                  getHintedTextFormField("Firstname", false, setFirstName,
                      Icons.person, getFirstNameValidator),
                  SizedBox(height: 8.0),
                  getHintedTextFormField("Lastname", false, setLastName,
                      Icons.person, getLastNameValidator),
                  SizedBox(height: 8.0),
                  getHintedTextFormField(
                      "Email", false, setEmail, Icons.email, getEmailValidator),
                  SizedBox(height: 8.0),
                  getHintedTextFormField("Password", true, setPassword,
                      Icons.security, getPasswordValidator),
                  SizedBox(height: 24.0),
                  getRegisterButton(),
                ],
              ),
            ),
          );
        }));
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

  Widget getLogo() {
    return Container();
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

  Widget getRegisterButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: register,
        padding: EdgeInsets.all(12),
        color: MyColors.accent,
        child: Text('Register now', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void register() {
    UiHelper.setCurrentScaffoldContext(_buildContext);
    Stream.value(_formKey.currentState.validate())
        .where((b) => b)
        .map((b) => fillRegisterObject(b))
        .flatMap((register) => _userService.register(register))
        .where((isLogin) => isLogin)
        .map((isLogin) => navigateHome())
        .listen(onData);
  }

  void initFields() {
    _register = new Register();
    _userService = new UserService();
  }

  navigateHome() {
    Navigator.of(context).pushReplacementNamed(MainLoginActivity.tag);
  }

  Register fillRegisterObject(bool b) {
    _formKey.currentState.save();
    return _register;
  }

  void onData(event) {
  }
}

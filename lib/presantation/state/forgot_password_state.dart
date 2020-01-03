import 'package:earthquake/data/model/login.dart';
import 'package:earthquake/presantation/activity/forgot_password_activity.dart';
import 'package:flutter/material.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class ForgotPasswordState extends State<ForgotPasswordActivity> {
  BuildContext _buildContext;
  Login _login;

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
          return Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                getLogo(),
                SizedBox(height: 48.0),
                getHintedTextFormField("Email", false, setEmail, Icons.person),
                SizedBox(height: 24.0),
                getForgotPasswordButton(),
              ],
            ),
          );
        }));
  }

  setEmail(String email) {
    _login.email = email;
  }

  Widget getLogo() {
    return Container();
  }

  Widget getHintedTextFormField(
      String hint, bool obscure, Function onSaved, IconData icon) {
    return new TextField(
      onChanged: onSaved,
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
    print("forgot password");
    UiHelper.setCurrentScaffoldContext(_buildContext);
  }
}

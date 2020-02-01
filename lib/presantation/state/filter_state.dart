import 'package:earthquake/data/model/change_password.dart';
import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/change_password_activity.dart';
import 'package:earthquake/presantation/activity/filter_activity.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../my_colors.dart';
import '../ui_helper.dart';

class FilterState extends State<FilterActivity> {
  BuildContext _buildContext;

  final _formKey = GlobalKey<FormState>();
  UserService _userService;
  Filter _filter;

  FilterState({Filter filter}) {
    _filter = filter;
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Filter'),
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
                  getHintedTextFormField("Old Password", true, setOldPassword,
                      Icons.lock, getPasswordValidator),
                  SizedBox(height: 8.0),
                  getHintedTextFormField("New Password", true, setNewPassword,
                      Icons.lock, getPasswordValidator),
                  SizedBox(height: 24.0),
                  getChangePasswordButton(),
                ],
              ),
            ),
          );
        }));
  }

  Widget getLogo() {
    return Container();
  }

  String getPasswordValidator(String s) {
    if (!Util.getStringLengthValidator(s, 6))
      return "Password should be greater than 5 char";
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

  Widget getChangePasswordButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onPressed: changePassword,
        padding: EdgeInsets.all(12),
        color: MyColors.accent,
        child: Text('Change Password', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void changePassword() {
    UiHelper.setCurrentScaffoldContext(_buildContext);
    Stream.value(_formKey.currentState.validate())
        .where((b) => b)
        .map((b) => saveState(b))
       /* .flatMap(
            (changePassword) => _userService.changePassword(changePassword))*/
        .flatMap((user) => _userService.logout())
        .listen(onSuccess);
  }

  void initFields() {
    _userService = new UserService();
    if (_filter == null) _filter = new Filter();
  }

  Filter saveState(bool b) {
    _formKey.currentState.save();
    return _filter;
  }

  onSuccess(bool user) {
    Navigator.pop(_buildContext);
  }

  setOldPassword(String password) {

  }

  setNewPassword(String password) {
  }
}

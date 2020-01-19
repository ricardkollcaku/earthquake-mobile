import 'package:earthquake/data/model/user.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/presantation/activity/change_password_activity.dart';
import 'package:earthquake/presantation/fragment/settings_fragment.dart';
import 'package:flutter/material.dart';

class SettingsState extends State<SettingsFragment> {
  UserService _userService;
  User _user;


  SettingsState(User user) {
    _user = user;
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [getChangePassword(), getNotification()],
    );
  }


  void initFields() {
    _userService = new UserService();
  }


  Widget getNotification() {
    return Card(
      child: SwitchListTile(
        value: _user.isNotificationEnabled,
        title: Text("Earthquake Notifications"),
        onChanged: setNotification,
      ),
    );
  }

  Widget getChangePassword() {
    return Card(
      child: ListTile(
        title: Text("Change password"),
        onTap: changePassword,
        trailing: Icon(Icons.security),
      ),
    );
  }

  void setNotification(bool value) {
    User user = User.clone(_user);
    user.isNotificationEnabled = value;
    _userService.setNotificationToUser(user).listen(updateUser);
  }

  void changePassword() {
    Navigator.pushNamed(context, ChangePasswordActivity.tag);
  }

  void updateUser(User user) {
    setState(() {
      _user = user;
    });
  }
}

import 'package:earthquake/data/model/user.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/presantation/activity/change_password_activity.dart';
import 'package:earthquake/presantation/fragment/settings_fragment.dart';
import 'package:earthquake/presantation/provider/app_bar_provider.dart';
import 'package:flutter/material.dart';

import '../my_colors.dart';

class SettingsState extends State<SettingsFragment> {
  UserService _userService;
  AppBarProvider _appBarProvider;

  SettingsState() {
    initFields();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _appBarProvider.context = context;

    return CustomScrollView(
      slivers: <Widget>[ SliverAppBar(
        actions: _appBarProvider.getActions(),
        pinned: true,
        expandedHeight: 200.0,
        backgroundColor: MyColors.accent,
        flexibleSpace: FlexibleSpaceBar(
          background: Image.network(
            "https://static.makeuseof.com/wp-content/uploads/2018/01/android-settings-670x335.jpg",
            fit: BoxFit.cover,),
          title: Text("My Settings",),

        ),
      ), SliverList(
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return getSettingsWidget(index);
              },
              childCount: 2
          )),
      ]
      ,
    );
  }


  void initFields() {
    _userService = new UserService();
    _appBarProvider = new AppBarProvider(context);

  }


  Widget getNotification() {
    return Card(
      child: SwitchListTile(
        value: UserService.user.isNotificationEnabled,
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
    User user = User.clone(UserService.user);
    user.isNotificationEnabled = value;
    _userService.setNotificationToUser(user).listen(updateUser);
  }

  void changePassword() {
    Navigator.pushNamed(context, ChangePasswordActivity.tag);
  }

  void updateUser(User user) {
    setState(() {
      UserService.user = user;
    });
  }

  Widget getSettingsWidget(int index) {
    if (index == 0)
      return getChangePassword();
    if (index == 1)
      return getNotification();
  }
}

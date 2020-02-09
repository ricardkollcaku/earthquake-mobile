import 'package:earthquake/data/model/choice.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarProvider {
  BuildContext _context;
  UserService _userService;

  AppBarProvider(BuildContext context) {
    _context = context;
    _userService = new UserService();
  }

  set context(BuildContext value) {
    _context = value;
  }

  AppBar getUserAppBar() {
    return AppBar(
      title: Text('Earthquake'),
      actions: getActions(),
    );
  }

  List<Widget> getActions() {
    return <Widget>[
      PopupMenuButton<Choice>(
        onSelected: _onMenuSelected,
        itemBuilder: (BuildContext context) {
          return (UserService.user == null ? _choicesNotLogedin : _choices)
              .map((Choice choice) {
            return PopupMenuItem<Choice>(
                value: choice, child: Text(choice.prop1));
          }).toList();
        },
      ),
    ];
  }

  void _onMenuSelected(Choice value) {
    if (value == _choices[1]) logout();
  }

  List<Choice> _choices = <Choice>[
    Choice(prop1: 'Contact Us', prop2: Icons.phone),
    Choice(prop1: 'Logout', prop2: Icons.exit_to_app),
  ];

  List<Choice> _choicesNotLogedin = <Choice>[
    Choice(prop1: 'Contact Us', prop2: Icons.phone),
  ];

  void logout() {
    _userService.logout().listen(onData);
    Navigator.of(_context).pushReplacementNamed(MainNonLoginActivity.tag);
  }

  void onData(bool event) {}
}

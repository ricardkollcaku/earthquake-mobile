import 'package:earthquake/data/model/user.dart';
import 'package:earthquake/domain/services/user_service.dart';
import 'package:earthquake/presantation/activity/filter_activity.dart';
import 'package:earthquake/presantation/activity/main_login_activity.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:earthquake/presantation/fragment/earthquake_list_fragment.dart';
import 'package:earthquake/presantation/fragment/filter_list_fragment.dart';
import 'package:earthquake/presantation/fragment/settings_fragment.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:flutter/material.dart';

import '../ui_helper.dart';

class MainLoginState extends State<MainLoginActivity> {
  BuildContext _buildContext;

  int _selectedBottomNavigationBarIndex;
  Widget _currentActiveFragment;
  UserService _userService;
  Widget _fab;
  MainLoginState() {
    initVariables();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
  //    appBar: getAppBar(),
      floatingActionButton: _fab,
      body: Builder(builder: (BuildContext context) {
        UiHelper.setCurrentScaffoldContext(context);
        return _currentActiveFragment;
      }),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text('Earthquake'),
      actions: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: _onMenuSelected,
          itemBuilder: (BuildContext context) {
            return _choices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                  value: choice, child: Text(choice.prop1)
              );
            }).toList();
          },
        ),
      ],
    );
  }

  BottomNavigationBar getBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedBottomNavigationBarIndex,
      onTap: _onBottomNavigationBarItemSelected,
      items:
      _fragments.map((choice) => choice.prop2)
          .map((dynami) => ((dynami as BottomNavigationBarItem)))
          .toList(),
    );
  }

  void onSearchClicked() {
  }

  void _onMenuSelected(Choice value) {
    if (value == _choices[1])
      logout();
  }

  List<Choice> _choices = <Choice>[
    Choice(prop1: 'Contact Us', prop2: Icons.phone),
    Choice(prop1: 'Logout', prop2: Icons.exit_to_app),
  ];

  List<Choice> _fragments = <Choice>[
    Choice(prop1: EarthquakeListFragment(), prop2: BottomNavigationBarItem(
        icon: Icon(Icons.map), title: Text('Earthquake'))),
    Choice(prop1: FilterListFragment(), prop2: BottomNavigationBarItem(
        icon: Icon(Icons.filter_tilt_shift), title: Text('Filters'))),
    Choice(prop1: SettingsFragment(), prop2: BottomNavigationBarItem(
        icon: Icon(Icons.settings), title: Text('Settings')))
  ];


  void _onBottomNavigationBarItemSelected(int value) {
    setState(() {
      if (_fragments[value].prop1 is FilterListFragment)
        _fab = _getFab();
      else
        _fab = Container();
      _selectedBottomNavigationBarIndex = value;
      _currentActiveFragment = _fragments[value].prop1;
    });
  }

  void initVariables() {
    _fab = Container();
    _userService = new UserService();
    _selectedBottomNavigationBarIndex = 0;
    _currentActiveFragment = _fragments[0].prop1;
    _userService.getUser().map((user) => _setUser(user)).listen(onData);
  }

  void logout() {
    _userService.logout().listen(onData);
    Navigator.of(_buildContext)
        .pushReplacementNamed(MainNonLoginActivity.tag);
  }


  void onData(dynamic o) {
  }

  User _setUser(User user) {
    UserService.user = user;
    return user;
  }

  Widget _getFab() {
    return FloatingActionButton(child: Icon(Icons.add,color: MyColors.white,),onPressed: onFabPressed,);
  }

  void onFabPressed() {
    Navigator.of(_buildContext)
        .pushNamed(FilterActivity.tag).asStream().listen(openFilterFragment);
  }

  void openFilterFragment(Object event) {
    (_currentActiveFragment as FilterListFragment).filterListState.refreshState(
        null);
  }
}

class Choice {
  Choice({this.prop1, this.prop2});

  var prop1;
  var prop2;

}

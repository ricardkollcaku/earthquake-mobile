import 'package:earthquake/data/model/choice.dart';
import 'package:earthquake/presantation/activity/main_non_login_activity.dart';
import 'package:earthquake/presantation/fragment/earthquake_list_fragment.dart';
import 'package:earthquake/presantation/fragment/login_fragment.dart';
import 'package:flutter/material.dart';

import '../ui_helper.dart';

class MainNonLoginState extends State<MainNonLoginActivity> {
  BuildContext _buildContext;

  int _selectedBottomNavigationBarIndex;
  Widget _currentActiveFragment;

  MainNonLoginState() {
    initVariables();
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        UiHelper.setCurrentScaffoldContext(context);
        return _currentActiveFragment;
      }),
      bottomNavigationBar: getBottomNavigationBar(),
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


  List<Choice> _fragments = <Choice>[
    Choice(prop1: EarthquakeListFragment(), prop2: BottomNavigationBarItem(
        icon: Icon(Icons.map), title: Text('Earthquake'))),
    Choice(prop1: LoginFragment(), prop2: BottomNavigationBarItem(
        icon: Icon(Icons.perm_identity), title: Text('User')))
  ];


  void _onBottomNavigationBarItemSelected(int value) {
    setState(() {
      _selectedBottomNavigationBarIndex = value;
      _currentActiveFragment = _fragments[value].prop1;
    });
  }

  void initVariables() {
    _selectedBottomNavigationBarIndex = 0;
    _currentActiveFragment = _fragments[0].prop1;
  }

}



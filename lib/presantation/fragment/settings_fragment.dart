import 'package:earthquake/presantation/state/settings_state.dart';
import 'package:flutter/material.dart';

class SettingsFragment extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  SettingsFragment(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState(_scaffoldKey);
  }
}

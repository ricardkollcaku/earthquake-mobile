import 'package:earthquake/data/model/user.dart';
import 'package:earthquake/presantation/state/earthquake_list_state.dart';
import 'package:earthquake/presantation/state/filter_list_state.dart';
import 'package:earthquake/presantation/state/settings_state.dart';
import 'package:flutter/material.dart';

class SettingsFragment extends StatefulWidget {
  User _user;

  SettingsFragment(this._user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState(_user);
  }
}

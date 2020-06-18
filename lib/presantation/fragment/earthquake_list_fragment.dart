import 'package:earthquake/presantation/state/earthquake_list_state.dart';
import 'package:flutter/material.dart';

class EarthquakeListFragment extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey;

  EarthquakeListFragment(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EarthquakeListState(_scaffoldKey);
  }
}

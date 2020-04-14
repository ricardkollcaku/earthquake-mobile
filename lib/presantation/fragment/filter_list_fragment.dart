import 'package:earthquake/presantation/state/filter_list_state.dart';
import 'package:flutter/material.dart';

class FilterListFragment extends StatefulWidget {
  FilterListState filterListState;
  GlobalKey<ScaffoldState> _scaffoldKey;

  FilterListFragment(GlobalKey<ScaffoldState> scaffoldKey) {
    _scaffoldKey = scaffoldKey;
  }

  @override
  State<StatefulWidget> createState() {
    filterListState = new FilterListState(_scaffoldKey);
    return filterListState;
  }
}

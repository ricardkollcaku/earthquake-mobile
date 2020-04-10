import 'package:earthquake/data/model/filter.dart';
import 'package:earthquake/presantation/state/filter_state.dart';
import 'package:flutter/material.dart';

class FilterActivity extends StatefulWidget {
  static const String tag = "filter_activity";

  Filter _filter;
  bool _actAsDialog=false;

  FilterActivity({Filter filter,bool actAsDialog=false}) {
    _filter = filter;
    _actAsDialog= actAsDialog;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FilterState(filter: _filter,actAsDialog: _actAsDialog);
  }
}

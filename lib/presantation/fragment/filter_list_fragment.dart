import 'package:earthquake/presantation/state/filter_list_state.dart';
import 'package:flutter/material.dart';

class FilterListFragment extends StatefulWidget {
  FilterListState filterListState;

  @override
  State<StatefulWidget> createState() {
    filterListState = new FilterListState();
    return filterListState;
  }
}

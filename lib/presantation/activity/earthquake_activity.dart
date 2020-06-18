import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/presantation/state/earthquake_state.dart';
import 'package:flutter/material.dart';

class EarthquakeActivity extends StatefulWidget {
  Earthquake _earthquake;

  EarthquakeActivity(this._earthquake);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EarthquakeState(_earthquake);
  }
}

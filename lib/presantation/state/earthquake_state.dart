import 'package:earthquake/data/model/earthquake.dart';
import 'package:earthquake/domain/util/util.dart';
import 'package:earthquake/presantation/activity/earthquake_activity.dart';
import 'package:earthquake/presantation/my_colors.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../ui_helper.dart';

class EarthquakeState extends State<EarthquakeActivity> {
  BuildContext _buildContext;

  final _formKey = GlobalKey<FormState>();
  Earthquake _earthquake;

  EarthquakeState(Earthquake earthquake) {
    _earthquake = earthquake;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(_earthquake.properties.title),
        ),
        body: Builder(builder: (BuildContext context) {
          _buildContext = context;
          UiHelper.setCurrentScaffoldContext(_buildContext);
          return Form(
            key: _formKey,
            child: GestureDetector(
              child: Card(
                child: Column(
                  children: <Widget>[
                    getMap(context, _earthquake),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      children: <Widget>[
                        SizedBox(height: 24.0),

                      ],
                    )
                  ],
                ),
              ),
              onTap: removeFocus,
            ),
          );
        }));
  }

  void removeFocus() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String getEarthquakeValidator(String s) {
    if (!Util.getStringLengthValidator(s, 6))
      return "Earthquake should be greater than 5 char";
    return null;
  }

  Widget getHintedTextFormField(String hint, bool obscure, Function onSaved,
      IconData icon, Function(String) validator) {
    return new TextFormField(
      validator: validator,
      onSaved: onSaved,
      autofocus: false,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _getCountryFlag(String countryCode) {
    if (countryCode == null)
      return Container(
        width: 15,
        height: 15,
      );
    try {
      return Flags.getMiniFlag(countryCode, null, 30);
    } catch (e) {
      return Container(
        width: 15,
        height: 15,
      );
    }
  }

  Widget getMap(BuildContext context, Earthquake earthquake) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 250,
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(earthquake.geometry.coordinates[1],
              earthquake.geometry.coordinates[0]),
          zoom: 10.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 15.0,
                height: 15.0,
                point: new LatLng(earthquake.geometry.coordinates[1],
                    earthquake.geometry.coordinates[0]),
                builder: (ctx) => Icon(
                  Icons.location_on,
                  color: MyColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class UiHelper {
  static BuildContext currentScaffoldContext;

  static void setCurrentScaffoldContext(BuildContext context) {
    currentScaffoldContext = context;
  }

  static void _showSms(String error) {
    print(error);
    Scaffold.of(currentScaffoldContext)
        .showSnackBar(SnackBar(content: Text(error == null ? "Error" : error)));
  }

  static void showError(String error) {
    _showSms(error);
  }

  int month = 1;
  int year;

  static _showDialog(BuildContext context, String title, String sms) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(sms),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showErrorLoginDialog(BuildContext context) {
    _showDialog(context, "Error", "username or password not valid");
  }

  static String formatTime(TimeOfDay t) {
    final now = new DateTime.now();
    DateTime dateTime =
        new DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat("HH:mm").format(dateTime);
  }

  static Widget getCountryFlag(String countryCode) {
    if (countryCode == "World") return Icon(Icons.terrain); //TODO put word icon
    if (countryCode == null) return Container();
    try {
      return Flags.getMiniFlag(countryCode, null, 50);
    } catch (e) {
      return Container();
    }
  }

  static Widget getCountryFlagMax(String countryCode) {
    if (countryCode == null) return Container();
    try {
      String assetName = 'packages/flag/res/svg1/' + countryCode + '.svg';
      Widget svg = new SvgPicture.asset(
        assetName,
        semanticsLabel: countryCode,
        fit: BoxFit.cover,
      );
      return svg;
    } catch (e) {
      return Container();
    }
  }

  static TileLayerOptions getMapTile() {
    return TileLayerOptions(
      urlTemplate: "https://api.tiles.mapbox.com/v4/"
          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoiZGFma3VhbHRpbiIsImEiOiJjazhpeGY1NHMwOHoyM2txbHgyajlleGgyIn0.nt_pd-RsSMAfR6g-LKgC3A',
        'id': 'mapbox.streets',
      },

      //    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      //   subdomains: ['a', 'b', 'c'],
      //  urlTemplate: 'http://tile.stamen.com/terrain/{z}/{x}/{y}.jpg',
    );
  }

  static Widget getHintedTextFormField(
      String hint,
      bool obscure,
      Function onSaved,
      IconData icon,
      Function(String) validator,
      Color primary) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        validator: validator,
        onSaved: onSaved,
        autofocus: false,
        obscureText: obscure,
        style: TextStyle(
          fontSize: 14,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: primary,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: primary,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: primary),
                child: Icon(icon),
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }

  static Widget button(String text, Color splashColor, Color highlightColor,
      Color fillColor, Color textColor, void function()) {
    return RaisedButton(
      highlightElevation: 0.0,
      splashColor: splashColor,
      highlightColor: highlightColor,
      elevation: 0.0,
      color: fillColor,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textColor, fontSize: 14),
      ),
      onPressed: () {
        function();
      },
    );
  }
}

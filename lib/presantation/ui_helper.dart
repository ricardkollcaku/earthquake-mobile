import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class UiHelper {
  static BuildContext currentScaffoldContext;

  static void setCurrentScaffoldContext(BuildContext context) {
    currentScaffoldContext = context;
  }

  static void _showSms(String error) {
    Scaffold.of(currentScaffoldContext).showSnackBar(SnackBar(
        content: Text(error == null ? "Error" : error)));
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
    if(countryCode=="World")
      return Icon(Icons.terrain); //TODO put word icon
    if (countryCode == null)
      return Container();
    try {
      return Flags.getMiniFlag(countryCode, null, 50);
    } catch (e) {
      return Container();
    }
  }

  static Widget getCountryFlagMax(String countryCode) {
    if (countryCode == null)
      return Container();
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
}

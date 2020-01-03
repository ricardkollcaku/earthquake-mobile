import 'dart:convert';

import 'package:earthquake/data/model/error.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UiHelper {
  static BuildContext currentScaffoldContext;

  static void setCurrentScaffoldContext(BuildContext context) {
    currentScaffoldContext = context;
  }

  static void _showSms(ErrorModel errorDto) {
    Scaffold.of(currentScaffoldContext).showSnackBar(SnackBar(
        content: Text(
            (errorDto.title != null ? errorDto.title : "Error" )+ "\n" +
                (errorDto.message != null ? errorDto.message : "Error"))));
  }

  static void showError(http.Response response) {
    _showSms(ErrorModel.fromJson(jsonDecode(response.body)));
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

  static void showErrorStreamResponse(http.StreamedResponse response) async {
    _showSms(ErrorModel.fromJson(
        jsonDecode((await(response.stream.bytesToString())))));
  }

}

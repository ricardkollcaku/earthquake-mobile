import 'package:flutter/material.dart';

class MyColors {
  static const Color accent = Color(0xFF00ADEF);
  static const Color primaryDark = Color(0xFFBDBDBD);
  static const Color primaryLight = Color(0xFFBBDEFB);
  static const Color primaryText = Color(0xFF464D53);
  static const Color secondaryText = Color(0xFF757575);
  static const Color white = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFBDBDBD);
  static const Color actionBarTextColor = Color(0xFF62686D);
  static const Color blueColorBackground = Color(0xFF238cf8);
  static const Color textNav = Color(0xFF212121);
  static const Color textMenuColor = Color(0xFF989FA7);
  static const Color error = Color(0xFFff0033);
  static const Color warning = Color(0xFFff9966);
  static const Color positive = Color(0xFF3CC9A4);
  static const Color background = Color(0xFFe8e8ea);
  static const Color shadowColor = Color(0xFF62686D);

  static getColor(double mag) {
    if (mag <= 4)
      return positive;
    else if (mag < 6)
      return warning;
    else
      return error;
  }
}

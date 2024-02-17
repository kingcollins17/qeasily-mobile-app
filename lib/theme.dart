// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
      colorScheme: ColorScheme.light(
    primary: Color(0xFF916BFF),
    secondary: Color(0xFF5C99FF),
          outline: Color(0xFF4B4B4B)
  ));
  static final dark = ThemeData(
      colorScheme: ColorScheme.dark(
    primary: Color(0xFF916BFF),
    secondary: Color(0xFF5C99FF),
          outline: Color(0xFFBDBDBD)
  ));
}

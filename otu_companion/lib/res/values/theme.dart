import 'package:flutter/material.dart';

class Themes
{

  static ThemeData mainAppTheme()
  {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      accentColor: Colors.blueAccent,

      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
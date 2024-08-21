import 'package:flutter/material.dart';

class MyThemes{

  // light theme
  static ThemeData lightTheme = ThemeData(
  
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    // primaryContainer: Colors.grey[400],
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);


  // dark theme
  static ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
 
  colorScheme: ColorScheme.fromSeed(
    // primaryContainer: Colors.grey[800],
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);
}
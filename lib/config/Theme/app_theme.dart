import 'package:flutter/material.dart';
import 'package:scattegories/core/utils/constants.dart';

final darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  hintColor: Colors.white,
  dividerColor: Colors.black12,
  backgroundColor: Color(0xFF303030),
  colorScheme: ColorScheme.dark(
    primary: Colors.blueGrey,
    background:  Colors.black,
  ),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE8DEB2), // Set the background color here
  hintColor: Colors.black,
  dividerColor: Colors.white54,
  colorScheme: ColorScheme.light(
    primary: Colors.grey,
    background: const Color(0xFFE8DEB2),
  ),
);

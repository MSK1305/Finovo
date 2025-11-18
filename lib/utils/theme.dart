import 'package:flutter/material.dart';

/// theme.dart
/// -----------
/// Centralizes light and dark theme definitions for the app.
/// Currently minimal — can be expanded with custom fonts, colors, etc.

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
  brightness: Brightness.dark,
);

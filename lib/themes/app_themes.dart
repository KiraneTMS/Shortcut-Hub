// lib/app_themes.dart
import 'package:flutter/material.dart';
import 'custom_theme_extension.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white70,
  scaffoldBackgroundColor: Colors.white,
  extensions: [
    CustomThemeExtension(
      firstGradientColor: Colors.grey,
      secondGradientColor: Colors.grey[350],
      thirdGradientColor: Colors.grey[100]
    )
  ]
  
  // Define other properties as needed
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black87,
  scaffoldBackgroundColor: Colors.black,
  extensions: [
    CustomThemeExtension(
      firstGradientColor: Color(0xFF252525),
      secondGradientColor: Color(0xFF121212),
      thirdGradientColor: Color(0xFF0A0A0A)
    )
  ]
  // Define other properties as needed
);

final ThemeData customTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.purple,
  scaffoldBackgroundColor: Colors.purple.shade50,
  extensions: [
    CustomThemeExtension(
      firstGradientColor: Colors.grey,
      secondGradientColor: Colors.grey[350],
      thirdGradientColor: Colors.grey[100]
    )
  ]
  // Define other properties as needed
);

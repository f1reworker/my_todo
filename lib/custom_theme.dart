import 'package:flutter/material.dart';

class CustomTheme {
  Color get indigo => const Color(0xFF4218D9);
  Color get purple => const Color(0xFF0A109B);
  Color get orange => const Color(0xFFFD7D20);
  Color get redIcon => const Color(0xFFF21905);
  Color get blackIcon => const Color(0xFF1E2124);
  Color get grayDivider => const Color(0xFF8F8F8F);
  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: 'Ubuntu',
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          secondary: Color(0xFFACABAB),
          background: Color(0xFFFDFDFD),
          primary: Color(0xFFFFFFFF),
        ));
  }
}

class Languages {}

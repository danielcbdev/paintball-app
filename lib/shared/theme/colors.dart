import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF526D82);
  static const Color primaryColorLight = Color(0xFF485F72);
  static const Color primaryColorDark = Color(0xFF3B4D5D);
  static const Color secondaryColor = Color(0xFF35a989);
  static const Color backgroundColor = Color(0xFFffffff);
  // static const Color backgroundColor = Color(0xFFE5E2E2);
  static const Color primaryGreen = Color(0xFF35a989);
  static const Color primaryBlue = Color(0xFF4A5FC6);
  static const Color primaryRed = Color(0xFFF16C69);
  static const Color primaryRedDark = Color(0xFF7F0000);

  static const Color primaryGreyLight = Color(0xFFF3F3F3);
  static const Color primaryGreyMedium = Color(0xFFC4C4C4);
  static const Color primaryGreyDark = Color(0xFF9E9E9E);
  static const Color primaryGreyDarkText = Color(0xFF707070);

  //? Primary Colors
  static const Color primaryPink = Color(0xFFDF3254);
  static const Color primaryPurple = Color(0xFF552E5B);
  static const Color primaryPurpleLight = Color(0xFF623E68);
  static const Color primaryPurpleTransparent = Color(0x8B623E68);
  static const Color primaryYellow = Color(0xFFFFCC29);
  static const Color primaryOrange = Color(0xFFEF8713);

  static const primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4CBAE5),
      Color(0xFF47ADD5),
      Color(0xFF409CC0),
      Color(0xFF3A8AA9),
    ],
    stops: [0.1, 0.4, 0.7, 0.9],
  );
}
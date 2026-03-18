import 'package:flutter/material.dart';
import 'index_theme.dart';
import '../../app_utils/index_app_util.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: RAppBarTheme.lightAppBarTheme,
    useMaterial3: true,
    fontFamily: "poppins",
    brightness: Brightness.light,
    primaryColor: RColors.primary,
    textTheme: RTextTheme.lightTextTheme,
    scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: RElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: RTextFormFieldTheme.lightInputDecorationTheme,
    //  splashColor: Colors.transparent,
    // highlightColor: Colors.transparent,
    // hoverColor: Colors.transparent,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: RAppBarTheme.darkAppBarTheme,
    fontFamily: "poppins",
    brightness: Brightness.dark,
    primaryColor: RColors.primary,
    textTheme: RTextTheme.darkTextTheme,
    scaffoldBackgroundColor: Colors.black,
    elevatedButtonTheme: RElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: RTextFormFieldTheme.darkInputDecorationTheme,
    //  splashColor: Colors.transparent,
    // highlightColor: Colors.transparent,
    // hoverColor: Colors.transparent,
  );
}

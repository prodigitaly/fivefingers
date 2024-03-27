import 'package:flutter/material.dart';

import '../constant/color_constant.dart';

class AppTheme {
  AppTheme(_);

  //     ======================= Font Family =======================     //
  static const String defaultFont = 'Poppins';

  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: ZoomColorConstants.appScaffold,
    fontFamily: defaultFont,
    dividerColor: ZoomColorConstants.appTransparent,
    elevatedButtonTheme: elevatedButtonThemeData,
    appBarTheme: appBarTheme,
    inputDecorationTheme: inputDecorationTheme,
  );

  static ElevatedButtonThemeData elevatedButtonThemeData =
  ElevatedButtonThemeData(
    style: ButtonStyle(
      // backgroundColor: MaterialStateProperty.all(ZoomColorConstants.themeScaffold),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 26, vertical: 10)),
      elevation: MaterialStateProperty.all(0),
    ),
  );

  static AppBarTheme appBarTheme = const AppBarTheme(
    centerTitle: true,
    color: ZoomColorConstants.appPrimaryThemeColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: defaultFont,
      fontSize: 18,
      color: ZoomColorConstants.appWhite,
      fontWeight: FontWeight.w500,
    ),
  );

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    hintStyle: const TextStyle(
      fontFamily: defaultFont,
      fontSize: 16,
      color: ZoomColorConstants.appPrimaryThemeColor,
      letterSpacing: 0.48,
    ),
    filled: true,
    fillColor: ZoomColorConstants.appWhite,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: ZoomColorConstants.appTransparent),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: ZoomColorConstants.appTransparent),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: ZoomColorConstants.appTransparent),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: ZoomColorConstants.appPrimaryThemeColor, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: ZoomColorConstants.appWhite, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: ZoomColorConstants.appPrimaryThemeColor.withOpacity(0.6),
        width: 2,
      ),
    ),
  );
}
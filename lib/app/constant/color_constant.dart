import 'package:flutter/material.dart';

class ZoomColorConstants {
  static const Color appScaffold = Color(0xFFE5E5E5);
  static const Color appTransparent = Color(0x00000000);
  static const Color appPrimaryThemeColor = Colors.red;
  static const Color appWhite = Color(0xffFFFFFF);
  static const Color appBlack = Color(0xFF000000);
  static const Color appLightBlack = Color(0xFF2F2F2F);
  static const Color appRed = Colors.red;


  static Color hex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<BoxShadow> appBoxShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      spreadRadius: 0.2,
      color: appLightBlack.withOpacity(0.2),
      blurRadius: 2,
    ),
  ];
}

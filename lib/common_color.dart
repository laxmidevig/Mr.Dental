import 'package:flutter/material.dart';

class AppColors {
   static const Color background = Color(0xFFF5F5F5); // Light Grey
  static const Color black = Color(0xFF000000); // Pure Black
  static const Color red = Color(0xFFF44336); // Material Red 500
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color green = Color(0xFF4CAF50); // Material Green 500
  static const Color grey = Colors.grey; // medium grey
  static const Color blue = Colors.blue; // medium grey
  static const Color transparent = Colors.blue; // medium grey
  static const Color white = Colors.white; // medium grey
  static const Color blueGrey = Color(0xFFECEFF1);
  static const Color peacockBlue=Color(0xff004B6E);
}
class AppFontWeight {
  static const FontWeight normal = FontWeight.normal;
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium5 = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontStyle fontItalic =FontStyle.italic;

  static double small(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.03;

  static double medium(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.04;

  static double large(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.05;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
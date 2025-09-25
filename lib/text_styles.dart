import 'package:dental/common_color.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const Color backgroundColor = Color(0xFFFFF6FB);

  static double _fontSize(BuildContext context, double mobile, double tablet, double web) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return width * web; // Web/Desktop
    } else if (width >= 600) {
      return width * tablet; // Tablet
    } else {
      return width * mobile; // Mobile
    }
  }
  static TextStyle sectionHeading(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: _fontSize(context, 0.045, 0.035, 0.025),
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.black,
    );
  }

  static TextStyle appHeading(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: _fontSize(context, 0.04, 0.025, 0.022),
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.white,
    );
  }

  static TextStyle heading(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: _fontSize(context, 0.035, 0.028, 0.02),
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.white,
    );
  }

  static TextStyle labelText(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: _fontSize(context, 0.04, 0.025, 0.025),
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.black,
    );
  }
  static TextStyle largeText(BuildContext context, {Color? color}) {
    return TextStyle(
        fontSize: _fontSize(context, 0.04, 0.035, 0.02),
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.black,fontStyle: AppFontWeight.fontItalic
    );
  }
  static TextStyle valueText(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: _fontSize(context, 0.03, 0.018, 0.018),
      fontWeight: FontWeight.normal,
      color: color ?? Colors.grey,
    );
  }

  static TextStyle valueText1(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: _fontSize(context, 0.03, 0.025, 0.026),
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.black,
    );
  }

  static TextStyle errorText(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: _fontSize(context, 0.03, 0.025, 0.018),
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.red,
    );
  }
}

Widget sectionTitle(String title, BuildContext context, Color color) {
  final size = MediaQuery.of(context).size;
  double scale = (size.width + size.height) / 1.5;
  return Padding(
    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
          title,
          style: AppTextStyles.valueText(context, color: AppColors.black)

      ),
    ),
  );
}

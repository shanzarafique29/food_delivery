import 'package:flutter/material.dart';

class AppFonts {
  static const String googleSansRounded = 'GoogleSansRounded';
}

class GoogleSansRoundedStyles {
  static TextStyle thin({
    double size = 14,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w100,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.googleSansRounded,
      fontSize: size,
      color: color,
       height: height,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle extraLight({
    double size = 14,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w100,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.googleSansRounded,
      fontSize: size,
      color: color,
       height: height,
      fontWeight: FontWeight.w200,
    );
  }

  static TextStyle light({
    double size = 14,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w100,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.googleSansRounded,
      fontSize: size,
      color: color,
       height: height,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle regular({
    double size = 14,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w100,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.googleSansRounded,
      fontSize: size,
      color: color,
       height: height,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle medium({
    double size = 14,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w100,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.googleSansRounded,
      fontSize: size,
      color: color,
       height: height,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle bold({
    double size = 14,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w100,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.googleSansRounded,
      fontSize: size,
      color: color,
       height: height,
      fontWeight: FontWeight.w700,
    );
  }
}

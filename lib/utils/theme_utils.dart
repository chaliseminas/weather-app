import 'package:flutter/material.dart';
import 'package:weather/utils/colors.dart';
import 'package:weather/utils/dimens.dart';

class ThemeUtils {
  static ThemeData setTheme(context) {
    return ThemeData(
        primaryColor: primaryColor,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: primaryColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: primaryColor.withOpacity(0.6),
          selectionHandleColor: primaryColor,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: fontColor),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: fontColor,
              fontSize: fontHeadingXSmall),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent);
  }
}

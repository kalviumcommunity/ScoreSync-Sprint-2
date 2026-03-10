import 'package:flutter/material.dart';

// ----------------------------
// Responsive Breakpoints
// ----------------------------
class AppBreakpoints {
  static const double mobile = 360;
  static const double tablet = 600;
  static const double desktop = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet &&
      MediaQuery.of(context).size.width < desktop;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}

// ----------------------------
// App-wide Constants
// ----------------------------
class AppConstants {
  static const String appName = 'ScoreSync';
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
}
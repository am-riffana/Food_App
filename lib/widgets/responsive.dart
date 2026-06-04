import 'package:flutter/material.dart';

class Responsive {
  static double w(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double h(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return w(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return w(context) >= 600 && w(context) < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return w(context) >= 1024;
  }
}
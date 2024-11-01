import 'package:flutter/material.dart';

import 'package:pigment/pigment.dart';

/// Define all the colors to be used in application in this file
/// To use - import this file and call required string by:
///```dart
///      AppColors.<name>
///```
///For Color Names refer: http://chir.ag/projects/name-that-color/#6195ED
class AppColors {
  AppColors._();

  static final Color lightSilver = Pigment.fromString('#ced9de');
  static const Color TRANSPARENT = Colors.transparent;
  static final Color white = Pigment.fromString("#ffffff");

  static final Color black = Pigment.fromString('#000000');
  static final Color gray = Pigment.fromString('#969696');

  static final Color primary = Pigment.fromString('#ff8c00');
  static final Color primaryDark = Pigment.fromString('#9c5500');
  static final Color primaryLight = Pigment.fromString('#ff9f2b');
  static final Color shimmerBg = Pigment.fromString('#808080');
  static final Color shimmerOverlay = Pigment.fromString('#c9c9c9');
}

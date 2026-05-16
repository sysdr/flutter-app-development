import 'package:flutter/material.dart';

abstract final class TransitionConfig {
  static const Duration enterDuration = Duration(milliseconds: 300);
  static const Duration exitDuration  = Duration(milliseconds: 200);
  static const Duration heroDuration  = Duration(milliseconds: 350);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve heroCurve    = Curves.fastEaseInToSlowEaseOut;
  static const Curve reverseCurve = Curves.easeInCubic;
}

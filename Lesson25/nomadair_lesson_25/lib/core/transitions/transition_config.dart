import 'package:flutter/material.dart';

// Central place for every animation duration and curve used in
// NomadAir. Changing one value here updates the whole app.
//
// Design rationale:
//   enterDuration  300ms — fast enough to feel snappy on search results
//   exitDuration   200ms — exits should be faster than entrances
//   heroDuration   350ms — Hero flights need a little longer to read
//   defaultCurve   easeOutCubic — decelerating start, smooth finish
//   heroCurve      fastEaseInToSlowEaseOut — punchy then gentle
abstract final class TransitionConfig {
  static const Duration enterDuration = Duration(milliseconds: 300);
  static const Duration exitDuration  = Duration(milliseconds: 200);
  static const Duration heroDuration  = Duration(milliseconds: 350);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve heroCurve    = Curves.fastEaseInToSlowEaseOut;
  static const Curve reverseCurve = Curves.easeInCubic;
}

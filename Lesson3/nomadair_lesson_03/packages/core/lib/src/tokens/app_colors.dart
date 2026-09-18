import 'package:flutter/material.dart';

/// NomadAir design token — colour primitives.
///
/// [abstract final class] modifiers in Dart 3.x:
///   - [abstract]: cannot be instantiated (AppColors() is a compile error)
///   - [final]: cannot be subclassed (class X extends AppColors is a compile error)
///
/// Every colour in every widget must trace back to one of these constants.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────
  static const Color brandPrimary   = Color(0xFF1A73E8);
  static const Color brandSecondary = Color(0xFF34A853);
  static const Color brandAccent    = Color(0xFFE8A020);

  // ── Semantic ───────────────────────────────────────────────
  static const Color success = Color(0xFF34A853);
  static const Color error   = Color(0xFFEA4335);
  static const Color warning = Color(0xFFFBBC04);
  static const Color info    = Color(0xFF4285F4);

  // ── Neutral Light ──────────────────────────────────────────
  static const Color surfaceLight    = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color onSurfaceLight  = Color(0xFF202124);
  static const Color subtleLight     = Color(0xFF5F6368);

  // ── Neutral Dark ───────────────────────────────────────────
  static const Color surfaceDark    = Color(0xFF1E1E2E);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color onSurfaceDark  = Color(0xFFE8EAED);
  static const Color subtleDark     = Color(0xFF9AA0A6);
}

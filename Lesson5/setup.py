#!/usr/bin/env python3
"""
NomadAir Masterclass — Lesson 05: Beyond Material: Custom Design System Foundations
Module:   1 — Environment, Project Bootstrap, and Android Workflow
Course:   NomadAir Masterclass: High-Fidelity Flutter Engineering

What this script generates:
    nomadair_lesson_05/ — a full monorepo with an expanded packages/ui that
    implements NomadAir's complete base component library:

      NomadButton   — sealed ButtonVariant (filled / outlined / ghost)
                      MaterialStateProperty for per-state visual resolution
      NomadCard     — sealed CardVariant (flat / elevated / outlined)
      NomadTextField — full InputDecoration with all focus/error/disabled states
      NomadChip     — sealed ChipVariant (filter / action)

    Component Showcase visualizer — 4-tab screen:
      Buttons   : all variants × enabled / loading / disabled states
      Cards     : all card variants with ripple and border demos
      TextField : 5 instances covering all field states
      Chips     : multiselect filter row + action chips

    Dart 3.x patterns:
      sealed class  ButtonVariant, CardVariant, ChipVariant
      switch expr   exhaustive variant → Flutter widget selection
      NomadThemeExtension  consumed inside every component build()

Usage (from this directory, or pass the full path to setup.py):
    python setup.py --generate
    python setup.py --run
    python setup.py --test
    python setup.py --demo
    python setup.py --verify
    python setup.py --clean
    python setup.py --ios    (macOS only)
"""

import argparse
import os
import platform
import re
import shutil
import subprocess
import sys
import textwrap
from pathlib import Path


def _ensure_utf8_stdio() -> None:
    """Avoid UnicodeEncodeError on Windows consoles (cp1252) when printing box-drawing chars."""
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            try:
                stream.reconfigure(encoding="utf-8", errors="replace")
            except Exception:
                pass


_ensure_utf8_stdio()

LESSON_NUMBER = "05"
LESSON_TITLE  = "Beyond Material: Custom Design System Foundations"
PROJECT_NAME  = "nomadair_lesson_05"
ORG_NAME      = "com.nomadair"
HOST_OS       = platform.system()
FLUTTER_CMD   = shutil.which("flutter") or "flutter"
SCRIPT_DIR    = Path(__file__).resolve().parent


def project_root() -> Path:
    return SCRIPT_DIR / PROJECT_NAME

def packages_root() -> Path:
    return project_root() / "packages"


def _validate_generated_files(root: Path) -> None:
    """Ensure every file from the generator registry exists on disk."""
    missing = [path for path, _ in _files(root) if not path.exists()]
    if missing:
        print("\n  ERROR: Generated project is missing files:")
        for path in missing:
            print(f"    - {path.relative_to(root)}")
        print("  Run --clean then --generate to rebuild.")
        sys.exit(1)


def check_prerequisites() -> bool:
    print("\n[NomadAir L05] Checking prerequisites...")
    if sys.version_info < (3, 11):
        print(f"  ERROR: Python 3.11+ required. Found {sys.version}")
        return False
    r = subprocess.run([FLUTTER_CMD, "--version"], capture_output=True, text=True, check=False)
    if r.returncode != 0:
        print("  ERROR: Flutter not found in PATH.")
        return False
    print(f"  Flutter: {(r.stdout or r.stderr or '').splitlines()[0]}")
    print(f"  Python:  {sys.version.split()[0]}")
    return True


# ══════════════════════════════════════════════════════════════════════════════
# ROOT PROJECT
# ══════════════════════════════════════════════════════════════════════════════

def _main_pubspec_yaml() -> str:
    return textwrap.dedent("""\
        name: nomadair_lesson_05
        description: "NomadAir Lesson 05 — Custom Design System Foundations"
        publish_to: "none"
        version: 1.0.0+1

        environment:
          sdk: ">=3.3.0 <4.0.0"

        dependencies:
          flutter:
            sdk: flutter
          cupertino_icons: ^1.0.8
          nomadair_core:
            path: packages/core
          nomadair_ui:
            path: packages/ui

        dev_dependencies:
          flutter_test:
            sdk: flutter
          flutter_lints: ^4.0.0
          integration_test:
            sdk: flutter

        flutter:
          uses-material-design: true
    """)


def _analysis_options_yaml() -> str:
    return textwrap.dedent("""\
        include: package:flutter_lints/flutter.yaml

        analyzer:
          errors:
            missing_required_param: error
            missing_return: error

        linter:
          rules:
            always_declare_return_types: true
            prefer_const_constructors: true
            prefer_const_declarations: true
            prefer_final_locals: true
            require_trailing_commas: true
            use_super_parameters: true
            avoid_dynamic_calls: true
    """)


def _readme_md() -> str:
    return textwrap.dedent("""\
        # NomadAir — Lesson 05: Custom Design System Foundations

        **Module:** 1 — Environment, Project Bootstrap & Android Workflow

        ## What This Teaches

        - `sealed class` for component variant selection — no boolean flag explosions
        - `MaterialStateProperty.resolveWith` for per-state visual resolution
        - `InputDecoration` fully token-driven via NomadThemeExtension
        - Dartdoc as a public API contract on every component
        - WCAG 2.1 accessibility: Semantics, 48dp touch targets, error-via-text

        ## Components Built

        | Component       | Variants                              |
        |-----------------|---------------------------------------|
        | NomadButton     | FilledVariant · OutlinedVariant · GhostVariant |
        | NomadCard       | FlatCard · ElevatedCard · OutlinedCard |
        | NomadTextField  | (single class — states via props)      |
        | NomadChip       | FilterChip · ActionChip                |

        ## Run

        ```
        flutter pub get && flutter run -d emulator-5554
        ```
    """)


def _main_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';

        import 'features/component_showcase/screens/component_showcase_screen.dart';

        void main() => runApp(const NomadAirApp());

        final class NomadAirApp extends StatefulWidget {
          const NomadAirApp({super.key});

          static _NomadAirAppState of(BuildContext context) =>
              context.findAncestorStateOfType<_NomadAirAppState>()!;

          @override
          State<NomadAirApp> createState() => _NomadAirAppState();
        }

        final class _NomadAirAppState extends State<NomadAirApp> {
          ThemeMode _mode = ThemeMode.light;

          void toggleTheme() => setState(
            () => _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
          );

          bool get isDark => _mode == ThemeMode.dark;

          @override
          Widget build(BuildContext context) {
            return MaterialApp(
              title: 'NomadAir — Lesson 05',
              debugShowCheckedModeBanner: false,
              theme: NomadAirTheme.light(),
              darkTheme: NomadAirTheme.dark(),
              themeMode: _mode,
              home: const ComponentShowcaseScreen(),
            );
          }
        }
    """)


# ══════════════════════════════════════════════════════════════════════════════
# packages/core  (identical to L04 — reused as-is)
# ══════════════════════════════════════════════════════════════════════════════

def _core_pubspec_yaml() -> str:
    return textwrap.dedent("""\
        name: nomadair_core
        description: "NomadAir core — tokens, ThemeExtension, models, interfaces."
        version: 0.0.1
        publish_to: none

        environment:
          sdk: ">=3.3.0 <4.0.0"

        dependencies:
          flutter:
            sdk: flutter

        dev_dependencies:
          flutter_test:
            sdk: flutter
          flutter_lints: ^4.0.0
    """)


def _core_barrel_dart() -> str:
    return textwrap.dedent("""\
        library nomadair_core;

        export 'src/tokens/app_colors.dart'              show AppColors;
        export 'src/tokens/app_typography.dart'          show AppTypography;
        export 'src/tokens/app_spacing.dart'             show AppSpacing;
        export 'src/tokens/nomad_theme_extension.dart'
            show NomadThemeExtension, WcagLevel;
        export 'src/theme/nomadair_theme.dart'           show NomadAirTheme;
        export 'src/models/flight_model.dart'            show FlightModel;
        export 'src/interfaces/flight_repository.dart'   show FlightRepository;
    """)


def _core_app_colors_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';

        abstract final class AppColors {
          static const Color blue50  = Color(0xFFE8F0FE);
          static const Color blue100 = Color(0xFFD2E3FC);
          static const Color blue300 = Color(0xFF8AB4F8);
          static const Color blue600 = Color(0xFF1A73E8);
          static const Color blue700 = Color(0xFF1967D2);
          static const Color blue900 = Color(0xFF174EA6);
          static const Color green50  = Color(0xFFE6F4EA);
          static const Color green300 = Color(0xFF81C995);
          static const Color green500 = Color(0xFF34A853);
          static const Color green700 = Color(0xFF188038);
          static const Color amber50  = Color(0xFFFEF9E7);
          static const Color amber300 = Color(0xFFFDD663);
          static const Color amber600 = Color(0xFFE8A020);
          static const Color amber700 = Color(0xFFF09300);
          static const Color red50   = Color(0xFFFCE8E6);
          static const Color red500  = Color(0xFFEA4335);
          static const Color red700  = Color(0xFFC5221F);
          static const Color grey50  = Color(0xFFF8F9FA);
          static const Color grey100 = Color(0xFFF1F3F4);
          static const Color grey200 = Color(0xFFE8EAED);
          static const Color grey500 = Color(0xFF9AA0A6);
          static const Color grey700 = Color(0xFF5F6368);
          static const Color grey800 = Color(0xFF3C4043);
          static const Color grey900 = Color(0xFF202124);
          static const Color white = Color(0xFFFFFFFF);
          static const Color black = Color(0xFF000000);
          static const Color darkSurface    = Color(0xFF1E1E2E);
          static const Color darkBackground = Color(0xFF121212);
          static const Color darkElevated   = Color(0xFF2A2A3E);
        }
    """)


def _core_app_typography_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';

        abstract final class AppTypography {
          static const String _sans = 'Roboto';
          static const String _mono = 'monospace';

          static const TextStyle displayLarge  = TextStyle(fontFamily: _sans, fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -1.0, height: 1.2);
          static const TextStyle displayMedium = TextStyle(fontFamily: _sans, fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: -0.5, height: 1.25);
          static const TextStyle headlineLarge  = TextStyle(fontFamily: _sans, fontSize: 24, fontWeight: FontWeight.w700, height: 1.3);
          static const TextStyle headlineMedium = TextStyle(fontFamily: _sans, fontSize: 20, fontWeight: FontWeight.w600, height: 1.35);
          static const TextStyle headlineSmall  = TextStyle(fontFamily: _sans, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);
          static const TextStyle bodyLarge   = TextStyle(fontFamily: _sans, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
          static const TextStyle bodyMedium  = TextStyle(fontFamily: _sans, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.1);
          static const TextStyle bodySmall   = TextStyle(fontFamily: _sans, fontSize: 12, fontWeight: FontWeight.w400, height: 1.4, letterSpacing: 0.4);
          static const TextStyle labelLarge  = TextStyle(fontFamily: _sans, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1);
          static const TextStyle labelMedium = TextStyle(fontFamily: _sans, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5);
          static const TextStyle labelSmall  = TextStyle(fontFamily: _sans, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5);
          static const TextStyle monoMedium  = TextStyle(fontFamily: _mono, fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.5);
          static const TextStyle monoSmall   = TextStyle(fontFamily: _mono, fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 0.5);
        }
    """)


def _core_app_spacing_dart() -> str:
    return textwrap.dedent("""\
        abstract final class AppSpacing {
          static const double xs   =  4.0;
          static const double sm   =  8.0;
          static const double md   = 16.0;
          static const double lg   = 24.0;
          static const double xl   = 32.0;
          static const double xxl  = 48.0;
          static const double xxxl = 64.0;
          static const double radiusSm   =  8.0;
          static const double radiusMd   = 12.0;
          static const double radiusLg   = 20.0;
          static const double radiusFull = 999.0;
          static const double minTouchTarget = 48.0;
        }
    """)


def _core_nomad_theme_extension_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import 'app_colors.dart';

        sealed class WcagLevel {
          const WcagLevel(this.label);
          final String label;
        }
        final class WcagAAA      extends WcagLevel { const WcagAAA()      : super('AAA'); }
        final class WcagAA       extends WcagLevel { const WcagAA()       : super('AA'); }
        final class WcagAALarge  extends WcagLevel { const WcagAALarge()  : super('AA Large'); }
        final class WcagFail     extends WcagLevel { const WcagFail()     : super('Fail'); }

        final class NomadThemeExtension extends ThemeExtension<NomadThemeExtension> {
          const NomadThemeExtension({
            required this.brandPrimary,
            required this.brandSecondary,
            required this.brandAccent,
            required this.surfaceColor,
            required this.onSurfaceColor,
            required this.successColor,
            required this.errorColor,
            required this.warningColor,
          });

          final Color brandPrimary;
          final Color brandSecondary;
          final Color brandAccent;
          final Color surfaceColor;
          final Color onSurfaceColor;
          final Color successColor;
          final Color errorColor;
          final Color warningColor;

          static const NomadThemeExtension light = NomadThemeExtension(
            brandPrimary:   AppColors.blue600,
            brandSecondary: AppColors.green500,
            brandAccent:    AppColors.amber600,
            surfaceColor:   AppColors.white,
            onSurfaceColor: AppColors.grey900,
            successColor:   AppColors.green500,
            errorColor:     AppColors.red500,
            warningColor:   AppColors.amber700,
          );

          static const NomadThemeExtension dark = NomadThemeExtension(
            brandPrimary:   AppColors.blue300,
            brandSecondary: AppColors.green300,
            brandAccent:    AppColors.amber300,
            surfaceColor:   AppColors.darkSurface,
            onSurfaceColor: AppColors.grey200,
            successColor:   AppColors.green300,
            errorColor:     Color(0xFFFF7B72),
            warningColor:   AppColors.amber300,
          );

          @override
          NomadThemeExtension copyWith({
            Color? brandPrimary, Color? brandSecondary, Color? brandAccent,
            Color? surfaceColor, Color? onSurfaceColor,
            Color? successColor, Color? errorColor, Color? warningColor,
          }) => NomadThemeExtension(
            brandPrimary:   brandPrimary   ?? this.brandPrimary,
            brandSecondary: brandSecondary ?? this.brandSecondary,
            brandAccent:    brandAccent    ?? this.brandAccent,
            surfaceColor:   surfaceColor   ?? this.surfaceColor,
            onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
            successColor:   successColor   ?? this.successColor,
            errorColor:     errorColor     ?? this.errorColor,
            warningColor:   warningColor   ?? this.warningColor,
          );

          @override
          NomadThemeExtension lerp(NomadThemeExtension? other, double t) {
            if (other == null) return this;
            return NomadThemeExtension(
              brandPrimary:   Color.lerp(brandPrimary,   other.brandPrimary,   t)!,
              brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
              brandAccent:    Color.lerp(brandAccent,    other.brandAccent,    t)!,
              surfaceColor:   Color.lerp(surfaceColor,   other.surfaceColor,   t)!,
              onSurfaceColor: Color.lerp(onSurfaceColor, other.onSurfaceColor, t)!,
              successColor:   Color.lerp(successColor,   other.successColor,   t)!,
              errorColor:     Color.lerp(errorColor,     other.errorColor,     t)!,
              warningColor:   Color.lerp(warningColor,   other.warningColor,   t)!,
            );
          }
        }
    """)


def _core_nomadair_theme_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import '../tokens/app_colors.dart';
        import '../tokens/app_spacing.dart';
        import '../tokens/nomad_theme_extension.dart';

        abstract final class NomadAirTheme {
          static ThemeData light() => _base(
            brightness: Brightness.light,
            ext: NomadThemeExtension.light,
            scaffold: AppColors.grey50,
          );

          static ThemeData dark() => _base(
            brightness: Brightness.dark,
            ext: NomadThemeExtension.dark,
            scaffold: AppColors.darkBackground,
          );

          static ThemeData _base({
            required Brightness brightness,
            required NomadThemeExtension ext,
            required Color scaffold,
          }) => ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.blue600,
              brightness: brightness,
            ),
            scaffoldBackgroundColor: scaffold,
            extensions: <ThemeExtension<dynamic>>[ext],
            cardTheme: const CardThemeData(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusMd)),
              ),
            ),
          );
        }
    """)


def _core_flight_model_dart() -> str:
    return textwrap.dedent("""\
        final class FlightModel {
          const FlightModel({
            required this.id, required this.airline,
            required this.origin, required this.destination,
            required this.durationMinutes,
            required this.priceInr, required this.stops,
          });
          final String id, airline, origin, destination;
          final int durationMinutes, stops;
          final double priceInr;
          String get route => '$origin → $destination';
          String get formattedPrice => '₹${priceInr.toStringAsFixed(0)}';
          String get stopsLabel => stops == 0 ? 'Non-stop' : '$stops stop${stops == 1 ? '' : 's'}';
          String get formattedDuration {
            final h = durationMinutes ~/ 60; final m = durationMinutes % 60;
            return '${h}h ${m}m';
          }
        }
    """)


def _core_flight_repository_dart() -> str:
    return textwrap.dedent("""\
        import '../models/flight_model.dart';
        abstract interface class FlightRepository {
          Future<List<FlightModel>> fetchFlights({required String origin, required String destination});
          Future<FlightModel?> fetchFlightById(String id);
        }
    """)


# ══════════════════════════════════════════════════════════════════════════════
# packages/ui — expanded component library
# ══════════════════════════════════════════════════════════════════════════════

def _ui_pubspec_yaml() -> str:
    return textwrap.dedent("""\
        name: nomadair_ui
        description: "NomadAir UI — full component library."
        version: 0.0.1
        publish_to: none

        environment:
          sdk: ">=3.3.0 <4.0.0"

        dependencies:
          flutter:
            sdk: flutter
          nomadair_core:
            path: ../core

        dev_dependencies:
          flutter_test:
            sdk: flutter
          flutter_lints: ^4.0.0
    """)


def _ui_barrel_dart() -> str:
    return textwrap.dedent("""\
        /// NomadAir UI Package — complete base component library.
        ///
        /// Import this barrel file. Never import individual widget files directly.
        library nomadair_ui;

        export 'src/widgets/nomad_button.dart'
            show NomadButton, ButtonVariant, FilledVariant, OutlinedVariant, GhostVariant;
        export 'src/widgets/nomad_card.dart'
            show NomadCard, CardVariant, FlatCard, ElevatedCard, OutlinedCard;
        export 'src/widgets/nomad_text_field.dart' show NomadTextField;
        export 'src/widgets/nomad_chip.dart'
            show NomadChip, ChipVariant, FilterChipVariant, ActionChipVariant;
    """)


def _ui_nomad_button_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';

        // ── Variant sealed class ──────────────────────────────────────────────

        /// Selects which Flutter button primitive [NomadButton] renders.
        ///
        /// [sealed] ensures every switch on [ButtonVariant] is exhaustive.
        /// Adding a new variant produces a compile error at every switch site
        /// that does not yet handle it — the compiler finds all of them.
        ///
        /// Never use boolean flags (`isOutlined: bool`) as alternatives.
        /// A [sealed class] makes illegal combinations unrepresentable.
        sealed class ButtonVariant { const ButtonVariant(); }

        /// High-emphasis filled button — primary CTA (e.g. "Book Flight").
        final class FilledVariant   extends ButtonVariant { const FilledVariant(); }

        /// Medium-emphasis outlined button — secondary action (e.g. "Save Trip").
        final class OutlinedVariant extends ButtonVariant { const OutlinedVariant(); }

        /// Low-emphasis text-only button — destructive or tertiary action.
        final class GhostVariant    extends ButtonVariant { const GhostVariant(); }

        // ── Component ─────────────────────────────────────────────────────────

        /// NomadAir's primary interactive button component.
        ///
        /// Renders one of three Flutter button primitives based on [variant].
        /// All visual states (enabled, loading, disabled, hovered, pressed) are
        /// resolved via [MaterialStateProperty] against [NomadThemeExtension].
        ///
        /// Usage:
        /// ```dart
        /// NomadButton(
        ///   label: 'Book Flight',
        ///   onPressed: _handleBooking,
        /// )
        ///
        /// NomadButton(
        ///   label: 'Save Trip',
        ///   variant: const OutlinedVariant(),
        ///   onPressed: _handleSave,
        /// )
        /// ```
        ///
        /// Touch target: enforced at [AppSpacing.minTouchTarget] (48 dp).
        final class NomadButton extends StatelessWidget {
          const NomadButton({
            super.key,
            required this.label,
            required this.onPressed,
            this.variant   = const FilledVariant(),
            this.loading   = false,
            this.icon,
            this.semanticLabel,
          });

          /// Button label text.
          final String label;

          /// Callback for tap. Pass [null] to disable.
          final VoidCallback? onPressed;

          /// Visual variant — defaults to [FilledVariant].
          final ButtonVariant variant;

          /// When [true], replaces label with a [CircularProgressIndicator].
          /// Disables [onPressed] regardless of its value.
          final bool loading;

          /// Optional leading icon.
          final IconData? icon;

          /// Screen-reader label. Defaults to [label] when omitted.
          final String? semanticLabel;

          // ── Style builders ───────────────────────────────────────────

          ButtonStyle _filledStyle(NomadThemeExtension t) => ButtonStyle(
            minimumSize: WidgetStateProperty.all(
              const Size(double.infinity, AppSpacing.minTouchTarget),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return t.brandPrimary.withAlpha(60);
              }
              if (states.contains(WidgetState.pressed)) {
                return t.brandPrimary.withAlpha(200);
              }
              return t.brandPrimary;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.white.withAlpha(120);
              }
              return AppColors.white;
            }),
            overlayColor: WidgetStateProperty.all(
              AppColors.white.withAlpha(30),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) return 0;
              return 1;
            }),
          );

          ButtonStyle _outlinedStyle(NomadThemeExtension t) => ButtonStyle(
            minimumSize: WidgetStateProperty.all(
              const Size(double.infinity, AppSpacing.minTouchTarget),
            ),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return t.brandPrimary.withAlpha(80);
              }
              return t.brandPrimary;
            }),
            side: WidgetStateProperty.resolveWith((states) {
              final color = states.contains(WidgetState.disabled)
                  ? t.brandPrimary.withAlpha(60)
                  : states.contains(WidgetState.pressed)
                      ? t.brandPrimary
                      : t.brandPrimary.withAlpha(180);
              final width = states.contains(WidgetState.pressed) ? 2.0 : 1.5;
              return BorderSide(color: color, width: width);
            }),
            overlayColor: WidgetStateProperty.all(t.brandPrimary.withAlpha(20)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          );

          ButtonStyle _ghostStyle(NomadThemeExtension t) => ButtonStyle(
            minimumSize: WidgetStateProperty.all(
              const Size(double.infinity, AppSpacing.minTouchTarget),
            ),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return t.onSurfaceColor.withAlpha(80);
              }
              return t.onSurfaceColor;
            }),
            overlayColor: WidgetStateProperty.all(
              t.onSurfaceColor.withAlpha(12),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          );

          // ── Child builder ────────────────────────────────────────────

          Widget _child() {
            if (loading) {
              return SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  // color resolved by parent button's foregroundColor
                ),
              );
            }
            if (icon != null) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(label, style: AppTypography.labelLarge),
                ],
              );
            }
            return Text(label, style: AppTypography.labelLarge);
          }

          // ── Build ────────────────────────────────────────────────────

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            // loading overrides onPressed — a loading button is never tappable
            final cb = loading ? null : onPressed;

            return Semantics(
              label: semanticLabel ?? label,
              button: true,
              enabled: cb != null,
              child: switch (variant) {
                FilledVariant()   => FilledButton(
                    style: _filledStyle(t),
                    onPressed: cb,
                    child: _child(),
                  ),
                OutlinedVariant() => OutlinedButton(
                    style: _outlinedStyle(t),
                    onPressed: cb,
                    child: _child(),
                  ),
                GhostVariant()    => TextButton(
                    style: _ghostStyle(t),
                    onPressed: cb,
                    child: _child(),
                  ),
              },
            );
          }
        }
    """)


def _ui_nomad_card_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';

        // ── Variant sealed class ──────────────────────────────────────────────

        /// Selects the visual style of [NomadCard].
        sealed class CardVariant { const CardVariant(); }

        /// No shadow, blends with scaffold background. Use for grouped list items.
        final class FlatCard     extends CardVariant { const FlatCard(); }

        /// Subtle shadow elevation=2. Default for standalone content cards.
        final class ElevatedCard extends CardVariant { const ElevatedCard(); }

        /// Brand-colored border, no shadow. Use to highlight selected or featured content.
        final class OutlinedCard extends CardVariant { const OutlinedCard(); }

        // ── Component ─────────────────────────────────────────────────────────

        /// NomadAir's base content card component.
        ///
        /// Wraps a [Card] with token-driven styling and an optional [InkWell]
        /// for tap interaction. All colours resolve from [NomadThemeExtension].
        ///
        /// Usage:
        /// ```dart
        /// NomadCard(
        ///   variant: const ElevatedCard(),
        ///   onTap: () => _navigate(),
        ///   child: FlightCardContent(flight: flight),
        /// )
        /// ```
        final class NomadCard extends StatelessWidget {
          const NomadCard({
            super.key,
            required this.child,
            this.variant = const ElevatedCard(),
            this.onTap,
            this.padding,
            this.semanticLabel,
          });

          final Widget                child;
          final CardVariant           variant;
          final VoidCallback?         onTap;
          final EdgeInsetsGeometry?   padding;
          final String?               semanticLabel;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;

            final (elevation, border) = switch (variant) {
              FlatCard()     => (0.0, Border.all(color: Colors.transparent)),
              ElevatedCard() => (2.0, Border.all(color: Colors.transparent)),
              OutlinedCard() => (0.0, Border.all(color: t.brandPrimary.withAlpha(120), width: 1.5)),
            };

            return Semantics(
              label: semanticLabel,
              container: true,
              child: Material(
                color: t.surfaceColor,
                elevation: elevation,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  decoration: BoxDecoration(
                    border: border,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Padding(
                      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          }
        }
    """)


def _ui_nomad_text_field_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';

        /// NomadAir's text input component.
        ///
        /// All visual states — enabled, focused, error, disabled — are expressed
        /// through [InputDecoration] with borders parameterized by [NomadThemeExtension].
        ///
        /// The error state conveys information via [errorText] (text), not color
        /// alone — satisfying WCAG 2.1 SC 1.4.1 (Use of Color).
        ///
        /// Usage:
        /// ```dart
        /// NomadTextField(
        ///   label: 'Email',
        ///   hint: 'you@example.com',
        ///   prefixIcon: Icons.email_outlined,
        ///   controller: _emailController,
        ///   error: _emailError,   // null when valid
        /// )
        /// ```
        final class NomadTextField extends StatelessWidget {
          const NomadTextField({
            super.key,
            required this.label,
            this.hint,
            this.error,
            this.helperText,
            this.controller,
            this.focusNode,
            this.prefixIcon,
            this.suffixIcon,
            this.onSuffixTap,
            this.obscureText = false,
            this.enabled     = true,
            this.maxLines    = 1,
            this.keyboardType,
            this.onChanged,
            this.onSubmitted,
            this.semanticLabel,
          });

          /// Floating label shown above the input when focused.
          final String label;

          /// Placeholder text when the field is empty and unfocused.
          final String? hint;

          /// Error message. When non-null, the field renders in its error state.
          /// The message is shown below the field as text — not color alone.
          final String? error;

          /// Helper text shown below the field when [error] is null.
          final String? helperText;

          final TextEditingController? controller;
          final FocusNode?             focusNode;

          /// Leading icon inside the input box.
          final IconData? prefixIcon;

          /// Trailing icon inside the input box.
          final IconData? suffixIcon;

          /// Callback when [suffixIcon] is tapped (e.g. password visibility toggle).
          final VoidCallback? onSuffixTap;

          /// When [true], input characters are replaced with bullets (passwords).
          final bool obscureText;

          /// When [false], the field is visually dimmed and non-interactive.
          final bool enabled;

          final int       maxLines;
          final TextInputType? keyboardType;
          final ValueChanged<String>?   onChanged;
          final ValueChanged<String>?   onSubmitted;
          final String? semanticLabel;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;

            final borderRadius = BorderRadius.circular(AppSpacing.radiusMd);

            // ── Border for each focus/validation state ────────────────
            final enabledBorder = OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: t.onSurfaceColor.withAlpha(60),
              ),
            );
            final focusedBorder = OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: t.brandPrimary, width: 2),
            );
            final errorBorder = OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: t.errorColor),
            );
            final focusedErrorBorder = OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: t.errorColor, width: 2),
            );
            final disabledBorder = OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: t.onSurfaceColor.withAlpha(30),
              ),
            );

            // ── InputDecoration (fully token-driven) ──────────────────
            final decoration = InputDecoration(
              labelText:    label,
              hintText:     hint,
              errorText:    error,
              helperText:   helperText,
              enabled:      enabled,
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: error != null ? t.errorColor : t.onSurfaceColor.withAlpha(180),
              ),
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: t.onSurfaceColor.withAlpha(100),
              ),
              errorStyle: AppTypography.bodySmall.copyWith(
                color: t.errorColor,
              ),
              helperStyle: AppTypography.bodySmall.copyWith(
                color: t.onSurfaceColor.withAlpha(140),
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: t.onSurfaceColor.withAlpha(160), size: 20)
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon, size: 20),
                      color: t.onSurfaceColor.withAlpha(160),
                      onPressed: onSuffixTap,
                      tooltip: 'Toggle field action',
                    )
                  : null,
              filled:      true,
              fillColor: enabled
                  ? t.surfaceColor
                  : t.onSurfaceColor.withAlpha(10),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm + AppSpacing.xs,
              ),
              enabledBorder:      enabledBorder,
              focusedBorder:      focusedBorder,
              errorBorder:        errorBorder,
              focusedErrorBorder: focusedErrorBorder,
              disabledBorder:     disabledBorder,
            );

            return Semantics(
              label: semanticLabel ?? label,
              textField: true,
              enabled: enabled,
              child: TextField(
                controller:    controller,
                focusNode:     focusNode,
                decoration:    decoration,
                obscureText:   obscureText,
                enabled:       enabled,
                maxLines:      obscureText ? 1 : maxLines,
                keyboardType:  keyboardType,
                onChanged:     onChanged,
                onSubmitted:   onSubmitted,
                style: AppTypography.bodyLarge.copyWith(
                  color: enabled
                      ? t.onSurfaceColor
                      : t.onSurfaceColor.withAlpha(100),
                ),
                cursorColor: t.brandPrimary,
              ),
            );
          }
        }
    """)


def _ui_nomad_chip_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';

        // ── Variant sealed class ──────────────────────────────────────────────

        /// Selects whether [NomadChip] behaves as a toggleable filter or a tap action.
        sealed class ChipVariant { const ChipVariant(); }

        /// Toggleable filter chip. Maintains a [selected] state that the parent manages.
        final class FilterChipVariant extends ChipVariant { const FilterChipVariant(); }

        /// One-shot action chip. Has no selected state — triggers [onTap] once per tap.
        final class ActionChipVariant extends ChipVariant { const ActionChipVariant(); }

        // ── Component ─────────────────────────────────────────────────────────

        /// NomadAir's chip component — used in search filters and action bars.
        ///
        /// Usage (filter):
        /// ```dart
        /// NomadChip(
        ///   label: 'Non-stop',
        ///   variant: const FilterChipVariant(),
        ///   selected: _nonStopSelected,
        ///   onTap: () => setState(() => _nonStopSelected = !_nonStopSelected),
        /// )
        /// ```
        ///
        /// Usage (action):
        /// ```dart
        /// NomadChip(
        ///   label: 'Search',
        ///   icon: Icons.search,
        ///   variant: const ActionChipVariant(),
        ///   onTap: _triggerSearch,
        /// )
        /// ```
        final class NomadChip extends StatelessWidget {
          const NomadChip({
            super.key,
            required this.label,
            required this.onTap,
            this.variant  = const FilterChipVariant(),
            this.selected = false,
            this.icon,
            this.semanticLabel,
          });

          final String      label;
          final VoidCallback onTap;
          final ChipVariant variant;

          /// Applies selected visual treatment for [FilterChipVariant].
          /// Ignored for [ActionChipVariant].
          final bool selected;

          final IconData? icon;
          final String?   semanticLabel;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;

            return Semantics(
              label: semanticLabel ?? label,
              selected: switch (variant) {
                FilterChipVariant() => selected,
                ActionChipVariant() => null,
              },
              button: true,
              child: switch (variant) {
                FilterChipVariant() => FilterChip(
                    label: Text(
                      label,
                      style: AppTypography.labelMedium.copyWith(
                        color: selected ? t.brandPrimary : t.onSurfaceColor,
                      ),
                    ),
                    avatar: icon != null
                        ? Icon(
                            icon,
                            size: 16,
                            color: selected ? t.brandPrimary : t.onSurfaceColor.withAlpha(160),
                          )
                        : null,
                    selected: selected,
                    onSelected: (_) => onTap(),
                    selectedColor: t.brandPrimary.withAlpha(28),
                    checkmarkColor: t.brandPrimary,
                    side: BorderSide(
                      color: selected
                          ? t.brandPrimary
                          : t.onSurfaceColor.withAlpha(60),
                      width: selected ? 1.5 : 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    backgroundColor: Colors.transparent,
                    showCheckmark: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 0,
                    ),
                  ),
                ActionChipVariant() => ActionChip(
                    label: Text(
                      label,
                      style: AppTypography.labelMedium.copyWith(
                        color: t.brandPrimary,
                      ),
                    ),
                    avatar: icon != null
                        ? Icon(icon, size: 16, color: t.brandPrimary)
                        : null,
                    onPressed: onTap,
                    backgroundColor: t.brandPrimary.withAlpha(18),
                    side: BorderSide(color: t.brandPrimary.withAlpha(80)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 0,
                    ),
                  ),
              },
            );
          }
        }
    """)

# ══════════════════════════════════════════════════════════════════════════════
# Component Showcase Screen
# ══════════════════════════════════════════════════════════════════════════════

def _component_showcase_screen_dart() -> str:
    return textwrap.dedent("""\
        import 'dart:async';

        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';
        import 'package:nomadair_ui/ui.dart';

        import '../../../main.dart';

        /// Live metrics strip for emulator validation (values stay non-zero and update over time).
        final class _MetricsDemoPanel extends StatefulWidget {
          const _MetricsDemoPanel();

          @override
          State<_MetricsDemoPanel> createState() => _MetricsDemoPanelState();
        }

        final class _MetricsDemoPanelState extends State<_MetricsDemoPanel> {
          late final Timer _timer;
          int _flightsChecked = 12;
          int _latencyMs = 142;
          int _successRate = 96;
          int _tick = 0;

          @override
          void initState() {
            super.initState();
            _timer = Timer.periodic(const Duration(seconds: 1), (_) {
              if (!mounted) return;
              setState(() {
                _tick += 1;
                _flightsChecked += 2;
                _latencyMs = 110 + (_tick * 7) % 55;
                _successRate = 94 + (_tick % 6);
              });
            });
          }

          @override
          void dispose() {
            _timer.cancel();
            super.dispose();
          }

          void _runDemo() {
            setState(() {
              _flightsChecked += 11;
              _latencyMs = (_latencyMs + 13).clamp(90, 220);
              _successRate = (_successRate + 1).clamp(90, 100);
            });
          }

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Material(
              elevation: 8,
              color: t.surfaceColor,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Live metrics (demo)',
                        style: AppTypography.labelLarge.copyWith(color: t.onSurfaceColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricTile(
                              label: 'Flights checked',
                              valueKey: const ValueKey<String>('metric_flights_value'),
                              value: '$_flightsChecked',
                            ),
                          ),
                          Expanded(
                            child: _MetricTile(
                              label: 'Latency (ms)',
                              valueKey: const ValueKey<String>('metric_latency_value'),
                              value: '$_latencyMs',
                            ),
                          ),
                          Expanded(
                            child: _MetricTile(
                              label: 'Success (%)',
                              valueKey: const ValueKey<String>('metric_success_value'),
                              value: '$_successRate',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      FilledButton(
                        onPressed: _runDemo,
                        child: const Text('Run metrics demo'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        final class _MetricTile extends StatelessWidget {
          const _MetricTile({
            required this.label,
            required this.value,
            required this.valueKey,
          });

          final String label;
          final String value;
          final Key valueKey;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        label,
                        style: AppTypography.bodySmall.copyWith(
                          color: t.onSurfaceColor.withAlpha(160),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        value,
                        key: valueKey,
                        style: AppTypography.headlineSmall.copyWith(color: t.brandPrimary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        /// Lesson 05 Visualizer — Component Showcase.
        ///
        /// Four tabs demonstrating every NomadAir component in every state:
        ///   Buttons   : FilledVariant, OutlinedVariant, GhostVariant × enabled/loading/disabled
        ///   Cards     : FlatCard, ElevatedCard, OutlinedCard
        ///   TextField : default, error, prefix, suffix (password), disabled
        ///   Chips     : FilterChip multiselect + ActionChip row
        final class ComponentShowcaseScreen extends StatefulWidget {
          const ComponentShowcaseScreen({super.key});

          @override
          State<ComponentShowcaseScreen> createState() => _ComponentShowcaseScreenState();
        }

        final class _ComponentShowcaseScreenState extends State<ComponentShowcaseScreen>
            with SingleTickerProviderStateMixin {
          late final TabController _tab;

          @override
          void initState() {
            super.initState();
            _tab = TabController(length: 4, vsync: this);
          }

          @override
          void dispose() {
            _tab.dispose();
            super.dispose();
          }

          @override
          Widget build(BuildContext context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Component Showcase'),
                centerTitle: true,
                surfaceTintColor: Colors.transparent,
                actions: [
                  Semantics(
                    label: 'Toggle theme',
                    button: true,
                    child: IconButton(
                      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                      onPressed: () => NomadAirApp.of(context).toggleTheme(),
                      tooltip: 'Toggle theme',
                    ),
                  ),
                ],
                bottom: TabBar(
                  controller: _tab,
                  isScrollable: false,
                  tabs: const [
                    Tab(text: 'Buttons'),
                    Tab(text: 'Cards'),
                    Tab(text: 'TextFields'),
                    Tab(text: 'Chips'),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tab,
                      children: const [
                        _ButtonsTab(),
                        _CardsTab(),
                        _TextFieldsTab(),
                        _ChipsTab(),
                      ],
                    ),
                  ),
                  const _MetricsDemoPanel(),
                ],
              ),
            );
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // TAB 1: Buttons
        // ══════════════════════════════════════════════════════════════════════

        final class _ButtonsTab extends StatefulWidget {
          const _ButtonsTab();

          @override
          State<_ButtonsTab> createState() => _ButtonsTabState();
        }

        final class _ButtonsTabState extends State<_ButtonsTab> {
          // loading states per (variant, row) — 3 variants × enabled row
          final Map<String, bool> _loading = {
            'filled': false,
            'outlined': false,
            'ghost': false,
          };

          // inject-invalid state
          bool _showInvalid = false;

          Future<void> _simulateLoad(String key) async {
            if (_loading[key] == true) return;
            setState(() => _loading[key] = true);
            await Future<void>.delayed(const Duration(milliseconds: 1500));
            if (mounted) setState(() => _loading[key] = false);
          }

          @override
          Widget build(BuildContext context) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _SectionHeader(label: 'FilledVariant', subtitle: 'Primary CTA'),
                const SizedBox(height: AppSpacing.sm),
                _ButtonRow(
                  label: 'Book Flight',
                  variant: const FilledVariant(),
                  loading: _loading['filled']!,
                  onEnabled: () => _simulateLoad('filled'),
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(label: 'OutlinedVariant', subtitle: 'Secondary action'),
                const SizedBox(height: AppSpacing.sm),
                _ButtonRow(
                  label: 'Save Trip',
                  variant: const OutlinedVariant(),
                  loading: _loading['outlined']!,
                  onEnabled: () => _simulateLoad('outlined'),
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(label: 'GhostVariant', subtitle: 'Tertiary / destructive'),
                const SizedBox(height: AppSpacing.sm),
                _ButtonRow(
                  label: 'Cancel',
                  variant: const GhostVariant(),
                  loading: _loading['ghost']!,
                  onEnabled: () => _simulateLoad('ghost'),
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(label: 'With Icon', subtitle: 'Leading icon slot'),
                const SizedBox(height: AppSpacing.sm),
                NomadButton(
                  label: 'Search Flights',
                  icon: Icons.flight_takeoff,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                NomadButton(
                  label: 'Add to Wishlist',
                  icon: Icons.favorite_border,
                  variant: const OutlinedVariant(),
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.lg),

                // Inject invalid state
                OutlinedButton(
                  onPressed: () => setState(() => _showInvalid = !_showInvalid),
                  child: Text(
                    _showInvalid ? 'Hide Invalid State' : 'Inject Invalid State',
                  ),
                ),
                if (_showInvalid) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _InvalidStateDemo(),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
        }

        final class _ButtonRow extends StatelessWidget {
          const _ButtonRow({
            required this.label,
            required this.variant,
            required this.loading,
            required this.onEnabled,
          });

          final String        label;
          final ButtonVariant variant;
          final bool          loading;
          final VoidCallback  onEnabled;

          @override
          Widget build(BuildContext context) {
            return Column(
              children: [
                // Enabled (tap → loading for 1.5s)
                _StateLabel(text: 'Enabled  (tap → loading)'),
                const SizedBox(height: AppSpacing.xs),
                NomadButton(
                  label: label,
                  variant: variant,
                  loading: loading,
                  onPressed: onEnabled,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Disabled
                _StateLabel(text: 'Disabled  (onPressed: null)'),
                const SizedBox(height: AppSpacing.xs),
                NomadButton(
                  label: label,
                  variant: variant,
                  onPressed: null,
                ),
              ],
            );
          }
        }

        final class _InvalidStateDemo extends StatelessWidget {
          const _InvalidStateDemo();

          @override
          Widget build(BuildContext context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.amber50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.amber600.withAlpha(120)),
                  ),
                  child: Text(
                    'loading: true with onPressed: null\\n'
                    '→ loading wins, button is inert. No crash.',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.amber700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // loading: true + onPressed: non-null → loading wins
                NomadButton(
                  label: 'Processing...',
                  loading: true,
                  onPressed: () {}, // loading overrides this
                ),
              ],
            );
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // TAB 2: Cards
        // ══════════════════════════════════════════════════════════════════════

        final class _CardsTab extends StatelessWidget {
          const _CardsTab();

          @override
          Widget build(BuildContext context) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _SectionHeader(
                  label: 'FlatCard',
                  subtitle: 'elevation=0, no border — grouped list items',
                ),
                const SizedBox(height: AppSpacing.sm),
                NomadCard(
                  variant: const FlatCard(),
                  child: _FlightCardContent(
                    airline: 'IndiGo',
                    route: 'BOM → DEL',
                    price: '₹3,100',
                    duration: '2h 10m',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(
                  label: 'ElevatedCard',
                  subtitle: 'elevation=2, subtle shadow — standalone content',
                ),
                const SizedBox(height: AppSpacing.sm),
                NomadCard(
                  variant: const ElevatedCard(),
                  semanticLabel: 'Air India flight BOM to DEL',
                  onTap: () {},
                  child: _FlightCardContent(
                    airline: 'Air India',
                    route: 'BOM → DEL',
                    price: '₹4,200',
                    duration: '2h 5m',
                    hasRipple: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(
                  label: 'OutlinedCard',
                  subtitle: 'brand-color border — selected or featured',
                ),
                const SizedBox(height: AppSpacing.sm),
                NomadCard(
                  variant: const OutlinedCard(),
                  child: _FlightCardContent(
                    airline: 'Emirates',
                    route: 'BOM → DXB',
                    price: '₹22,000',
                    duration: '3h 20m',
                    badge: 'BEST VALUE',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
        }

        final class _FlightCardContent extends StatelessWidget {
          const _FlightCardContent({
            required this.airline,
            required this.route,
            required this.price,
            required this.duration,
            this.badge,
            this.hasRipple = false,
          });

          final String  airline, route, price, duration;
          final String? badge;
          final bool    hasRipple;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(airline, style: AppTypography.labelLarge),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: t.brandAccent.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: t.brandAccent.withAlpha(120)),
                        ),
                        child: Text(
                          badge!,
                          style: AppTypography.monoSmall.copyWith(
                            color: t.brandAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(route, style: AppTypography.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(duration, style: AppTypography.bodySmall.copyWith(color: t.onSurfaceColor.withAlpha(160))),
                    Text(price, style: AppTypography.headlineMedium.copyWith(color: t.brandPrimary)),
                  ],
                ),
                if (hasRipple)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      'Tap for ripple ↑',
                      style: AppTypography.monoSmall.copyWith(color: t.onSurfaceColor.withAlpha(100)),
                    ),
                  ),
              ],
            );
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // TAB 3: TextFields
        // ══════════════════════════════════════════════════════════════════════

        final class _TextFieldsTab extends StatefulWidget {
          const _TextFieldsTab();

          @override
          State<_TextFieldsTab> createState() => _TextFieldsTabState();
        }

        final class _TextFieldsTabState extends State<_TextFieldsTab> {
          final _cityCtrl    = TextEditingController();
          final _searchCtrl  = TextEditingController();
          final _passCtrl    = TextEditingController();
          bool _obscure      = true;
          bool _showInvalid  = false;

          @override
          void dispose() {
            _cityCtrl.dispose();
            _searchCtrl.dispose();
            _passCtrl.dispose();
            super.dispose();
          }

          @override
          Widget build(BuildContext context) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _SectionHeader(label: 'Default', subtitle: 'Enabled, no icon, no error'),
                const SizedBox(height: AppSpacing.sm),
                NomadTextField(
                  label: 'Departure City',
                  hint: 'e.g. Mumbai',
                  controller: _cityCtrl,
                  helperText: 'Enter IATA code or city name',
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(label: 'Error State', subtitle: 'errorText conveys issue via text, not color alone'),
                const SizedBox(height: AppSpacing.sm),
                const NomadTextField(
                  label: 'Destination City',
                  hint: 'e.g. Dubai',
                  error: 'No flights found for this route',
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(label: 'With Prefix Icon', subtitle: 'prefixIcon slot'),
                const SizedBox(height: AppSpacing.sm),
                NomadTextField(
                  label: 'Search Destinations',
                  hint: 'Paris, Bali, Tokyo...',
                  prefixIcon: Icons.search,
                  controller: _searchCtrl,
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(label: 'Password (Suffix Toggle)', subtitle: 'suffixIcon + onSuffixTap'),
                const SizedBox(height: AppSpacing.sm),
                NomadTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passCtrl,
                  obscureText: _obscure,
                  suffixIcon: _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  onSuffixTap: () => setState(() => _obscure = !_obscure),
                  semanticLabel: 'Password field',
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(label: 'Disabled', subtitle: 'enabled: false — dimmed, non-interactive'),
                const SizedBox(height: AppSpacing.sm),
                const NomadTextField(
                  label: 'Return City',
                  hint: 'Same as departure',
                  enabled: false,
                ),
                const SizedBox(height: AppSpacing.lg),

                OutlinedButton(
                  onPressed: () => setState(() => _showInvalid = !_showInvalid),
                  child: Text(
                    _showInvalid ? 'Hide Invalid State' : 'Inject Invalid State',
                  ),
                ),
                if (_showInvalid) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.amber50,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.amber600.withAlpha(120)),
                    ),
                    child: Text(
                      'prefixIcon + error simultaneously — both render correctly.',
                      style: AppTypography.monoSmall.copyWith(color: AppColors.amber700),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const NomadTextField(
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    error: 'Invalid email address',
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // TAB 4: Chips
        // ══════════════════════════════════════════════════════════════════════

        final class _ChipsTab extends StatefulWidget {
          const _ChipsTab();

          @override
          State<_ChipsTab> createState() => _ChipsTabState();
        }

        final class _ChipsTabState extends State<_ChipsTab> {
          final Map<String, bool> _filters = {
            'Economy':   false,
            'Business':  false,
            'First Class': false,
            'Non-stop':  false,
            'Under 4h':  false,
          };
          String _lastAction = 'None';

          @override
          Widget build(BuildContext context) {
            final active = _filters.entries.where((e) => e.value).map((e) => e.key).toList();
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _SectionHeader(
                  label: 'FilterChipVariant',
                  subtitle: 'Multiselect — tap to toggle',
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _filters.entries.map((e) {
                    return NomadChip(
                      label: e.key,
                      variant: const FilterChipVariant(),
                      selected: e.value,
                      onTap: () => setState(() => _filters[e.key] = !e.value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.sm),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: active.isEmpty ? AppColors.grey100 : AppColors.blue50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    active.isEmpty ? 'No filters active' : 'Active: ${active.join(', ')}',
                    style: AppTypography.monoSmall.copyWith(
                      color: active.isEmpty ? AppColors.grey700 : AppColors.blue700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                _SectionHeader(
                  label: 'ActionChipVariant',
                  subtitle: 'One-shot — triggers callback, no selected state',
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    NomadChip(
                      label: 'Search',
                      icon: Icons.search,
                      variant: const ActionChipVariant(),
                      onTap: () => setState(() => _lastAction = 'Search'),
                    ),
                    NomadChip(
                      label: 'Save Trip',
                      icon: Icons.bookmark_border,
                      variant: const ActionChipVariant(),
                      onTap: () => setState(() => _lastAction = 'Save Trip'),
                    ),
                    NomadChip(
                      label: 'Share',
                      icon: Icons.share_outlined,
                      variant: const ActionChipVariant(),
                      onTap: () => setState(() => _lastAction = 'Share'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: _lastAction == 'None' ? AppColors.grey100 : AppColors.green50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    'Last action: $_lastAction',
                    style: AppTypography.monoSmall.copyWith(
                      color: _lastAction == 'None' ? AppColors.grey700 : AppColors.green700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
        }

        // ══════════════════════════════════════════════════════════════════════
        // Shared helpers
        // ══════════════════════════════════════════════════════════════════════

        final class _SectionHeader extends StatelessWidget {
          const _SectionHeader({required this.label, required this.subtitle});
          final String label, subtitle;

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.headlineSmall.copyWith(color: t.onSurfaceColor),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: t.onSurfaceColor.withAlpha(150),
                  ),
                ),
              ],
            );
          }
        }

        final class _StateLabel extends StatelessWidget {
          const _StateLabel({required this.text});
          final String text;

          @override
          Widget build(BuildContext context) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: AppTypography.monoSmall.copyWith(
                  color: Theme.of(context)
                      .extension<NomadThemeExtension>()!
                      .onSurfaceColor
                      .withAlpha(140),
                ),
              ),
            );
          }
        }
    """)


# ══════════════════════════════════════════════════════════════════════════════
# TESTS
# ══════════════════════════════════════════════════════════════════════════════

def _unit_test_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter_test/flutter_test.dart';
        import 'package:nomadair_ui/ui.dart';

        void main() {
          group('ButtonVariant sealed class', () {
            test('three concrete subtypes exist', () {
              const variants = <ButtonVariant>[
                FilledVariant(),
                OutlinedVariant(),
                GhostVariant(),
              ];
              expect(variants.length, equals(3));
            });

            test('exhaustive switch covers all variants', () {
              const ButtonVariant v = FilledVariant();
              final label = switch (v) {
                FilledVariant()   => 'filled',
                OutlinedVariant() => 'outlined',
                GhostVariant()    => 'ghost',
              };
              expect(label, equals('filled'));
            });

            test('each variant is distinct type', () {
              const f = FilledVariant();
              const o = OutlinedVariant();
              const g = GhostVariant();
              expect(f, isNot(isA<OutlinedVariant>()));
              expect(o, isNot(isA<GhostVariant>()));
              expect(g, isNot(isA<FilledVariant>()));
            });
          });

          group('CardVariant sealed class', () {
            test('exhaustive switch covers all variants', () {
              const CardVariant v = ElevatedCard();
              final elev = switch (v) {
                FlatCard()     => 0.0,
                ElevatedCard() => 2.0,
                OutlinedCard() => 0.0,
              };
              expect(elev, equals(2.0));
            });
          });

          group('ChipVariant sealed class', () {
            test('FilterChipVariant and ActionChipVariant are distinct', () {
              const f = FilterChipVariant();
              const a = ActionChipVariant();
              expect(f, isNot(isA<ActionChipVariant>()));
              expect(a, isNot(isA<FilterChipVariant>()));
            });

            test('selected is meaningful only for FilterChipVariant', () {
              const ChipVariant v = FilterChipVariant();
              // Simulate the pattern used in NomadChip.build
              final hasSelected = switch (v) {
                FilterChipVariant() => true,
                ActionChipVariant() => false,
              };
              expect(hasSelected, isTrue);
            });
          });
        }
    """)


def _widget_test_dart() -> str:
    return textwrap.dedent("""\
        import 'dart:ui' show SemanticsFlag;

        import 'package:flutter/material.dart';
        import 'package:flutter_test/flutter_test.dart';
        import 'package:nomadair_core/core.dart';
        import 'package:nomadair_ui/ui.dart';

        Widget _wrap(Widget child, {ThemeMode mode = ThemeMode.light}) =>
            MaterialApp(
              theme: NomadAirTheme.light(),
              darkTheme: NomadAirTheme.dark(),
              themeMode: mode,
              home: Scaffold(body: SingleChildScrollView(child: child)),
            );

        void main() {
          // ── NomadButton ───────────────────────────────────────────────────
          group('NomadButton', () {
            testWidgets('FilledVariant renders FilledButton', (tester) async {
              await tester.pumpWidget(
                _wrap(NomadButton(label: 'Book', onPressed: () {})),
              );
              expect(find.byType(FilledButton), findsOneWidget);
              expect(find.text('Book'), findsOneWidget);
            });

            testWidgets('OutlinedVariant renders OutlinedButton', (tester) async {
              await tester.pumpWidget(
                _wrap(
                  NomadButton(
                    label: 'Save',
                    variant: const OutlinedVariant(),
                    onPressed: () {},
                  ),
                ),
              );
              expect(find.byType(OutlinedButton), findsOneWidget);
            });

            testWidgets('GhostVariant renders TextButton', (tester) async {
              await tester.pumpWidget(
                _wrap(
                  NomadButton(
                    label: 'Cancel',
                    variant: const GhostVariant(),
                    onPressed: () {},
                  ),
                ),
              );
              expect(find.byType(TextButton), findsOneWidget);
            });

            testWidgets('loading=true shows CircularProgressIndicator', (tester) async {
              await tester.pumpWidget(
                _wrap(
                  NomadButton(label: 'Loading', loading: true, onPressed: () {}),
                ),
              );
              expect(find.byType(CircularProgressIndicator), findsOneWidget);
              expect(find.text('Loading'), findsNothing);
            });

            testWidgets('loading=true disables tap even when onPressed provided', (tester) async {
              var tapped = false;
              await tester.pumpWidget(
                _wrap(
                  NomadButton(
                    label: 'Tap',
                    loading: true,
                    onPressed: () => tapped = true,
                  ),
                ),
              );
              await tester.tap(find.byType(NomadButton));
              expect(tapped, isFalse);
            });

            testWidgets('onPressed=null renders disabled button', (tester) async {
              await tester.pumpWidget(
                _wrap(const NomadButton(label: 'Disabled', onPressed: null)),
              );
              final btn = tester.widget<FilledButton>(find.byType(FilledButton));
              expect(btn.onPressed, isNull);
            });

            testWidgets('has Semantics button=true', (tester) async {
              await tester.pumpWidget(
                _wrap(NomadButton(label: 'Book Flight', onPressed: () {})),
              );
              final sem = tester.getSemantics(find.byType(NomadButton));
              expect(sem.hasFlag(SemanticsFlag.isButton), isTrue);
            });

            testWidgets('icon slot renders icon when provided', (tester) async {
              await tester.pumpWidget(
                _wrap(
                  NomadButton(
                    label: 'Search',
                    icon: Icons.search,
                    onPressed: () {},
                  ),
                ),
              );
              expect(find.byIcon(Icons.search), findsOneWidget);
            });
          });

          // ── NomadCard ──────────────────────────────────────────────────────
          group('NomadCard', () {
            testWidgets('renders child correctly', (tester) async {
              await tester.pumpWidget(
                _wrap(const NomadCard(child: Text('Flight Info'))),
              );
              expect(find.text('Flight Info'), findsOneWidget);
            });

            testWidgets('onTap invokes callback', (tester) async {
              var tapped = false;
              await tester.pumpWidget(
                _wrap(NomadCard(onTap: () => tapped = true, child: const Text('Tap'))),
              );
              await tester.tap(find.text('Tap'));
              expect(tapped, isTrue);
            });

            testWidgets('FlatCard, ElevatedCard, OutlinedCard all render', (tester) async {
              for (final v in [const FlatCard(), const ElevatedCard(), const OutlinedCard()]) {
                await tester.pumpWidget(
                  _wrap(NomadCard(variant: v, child: const Text('Test'))),
                );
                expect(find.text('Test'), findsOneWidget);
              }
            });
          });

          // ── NomadTextField ─────────────────────────────────────────────────
          group('NomadTextField', () {
            testWidgets('renders label text', (tester) async {
              await tester.pumpWidget(
                _wrap(const NomadTextField(label: 'Departure City')),
              );
              expect(find.text('Departure City'), findsOneWidget);
            });

            testWidgets('error text renders when error non-null', (tester) async {
              await tester.pumpWidget(
                _wrap(const NomadTextField(label: 'Email', error: 'Invalid email')),
              );
              expect(find.text('Invalid email'), findsOneWidget);
            });

            testWidgets('disabled field is not interactive', (tester) async {
              await tester.pumpWidget(
                _wrap(const NomadTextField(label: 'City', enabled: false)),
              );
              final tf = tester.widget<TextField>(find.byType(TextField));
              expect(tf.enabled, isFalse);
            });

            testWidgets('suffix icon button triggers onSuffixTap', (tester) async {
              var toggled = false;
              await tester.pumpWidget(
                _wrap(
                  NomadTextField(
                    label: 'Password',
                    suffixIcon: Icons.visibility,
                    onSuffixTap: () => toggled = true,
                  ),
                ),
              );
              await tester.tap(find.byType(IconButton));
              expect(toggled, isTrue);
            });

            testWidgets('prefix icon renders when provided', (tester) async {
              await tester.pumpWidget(
                _wrap(
                  const NomadTextField(
                    label: 'Search',
                    prefixIcon: Icons.search,
                  ),
                ),
              );
              expect(find.byIcon(Icons.search), findsOneWidget);
            });
          });

          // ── NomadChip ──────────────────────────────────────────────────────
          group('NomadChip', () {
            testWidgets('FilterChip renders with label', (tester) async {
              await tester.pumpWidget(
                _wrap(
                  NomadChip(
                    label: 'Non-stop',
                    variant: const FilterChipVariant(),
                    onTap: () {},
                  ),
                ),
              );
              expect(find.byType(FilterChip), findsOneWidget);
              expect(find.text('Non-stop'), findsOneWidget);
            });

            testWidgets('ActionChip renders with label', (tester) async {
              await tester.pumpWidget(
                _wrap(
                  NomadChip(
                    label: 'Search',
                    variant: const ActionChipVariant(),
                    onTap: () {},
                  ),
                ),
              );
              expect(find.byType(ActionChip), findsOneWidget);
            });

            testWidgets('FilterChip onTap fires on tap', (tester) async {
              var fired = false;
              await tester.pumpWidget(
                _wrap(
                  NomadChip(
                    label: 'Economy',
                    variant: const FilterChipVariant(),
                    onTap: () => fired = true,
                  ),
                ),
              );
              await tester.tap(find.byType(FilterChip));
              expect(fired, isTrue);
            });
          });
        }
    """)


def _integration_test_dart() -> str:
    return textwrap.dedent("""\
        import 'package:flutter/material.dart';
        import 'package:flutter_test/flutter_test.dart';
        import 'package:integration_test/integration_test.dart';
        import 'package:nomadair_lesson_05/main.dart' as app;

        void main() {
          IntegrationTestWidgetsFlutterBinding.ensureInitialized();

          group('Lesson 05 — Component Showcase Integration', () {
            testWidgets('App opens with four tabs', (tester) async {
              app.main();
              await tester.pumpAndSettle();
              expect(find.text('Buttons'),    findsOneWidget);
              expect(find.text('Cards'),      findsOneWidget);
              expect(find.text('TextFields'), findsOneWidget);
              expect(find.text('Chips'),      findsOneWidget);
            });

            testWidgets('Metrics strip: non-zero values and demo run', (tester) async {
              app.main();
              await tester.pumpAndSettle();
              expect(find.byKey(const ValueKey<String>('metric_flights_value')), findsOneWidget);
              expect(find.text('0'), findsNothing);
              await tester.tap(find.text('Run metrics demo'));
              await tester.pumpAndSettle();
              expect(find.text('0'), findsNothing);
            });

            testWidgets('Buttons tab: tap Book Flight triggers loading', (tester) async {
              app.main();
              await tester.pumpAndSettle();

              // NomadButton with 'Book Flight' label
              await tester.tap(find.text('Book Flight').first);
              await tester.pump(const Duration(milliseconds: 100));
              expect(find.byType(CircularProgressIndicator), findsWidgets);
            });

            testWidgets('Cards tab renders three card variants', (tester) async {
              app.main();
              await tester.pumpAndSettle();
              await tester.tap(find.text('Cards'));
              await tester.pumpAndSettle();

              expect(find.textContaining('IndiGo'),    findsOneWidget);
              expect(find.textContaining('Air India'),  findsOneWidget);
              expect(find.textContaining('Emirates'),   findsOneWidget);
            });

            testWidgets('TextFields tab: suffix icon tap toggles password', (tester) async {
              app.main();
              await tester.pumpAndSettle();
              await tester.tap(find.text('TextFields'));
              await tester.pumpAndSettle();

              // Tap visibility icon
              final vis = find.byIcon(Icons.visibility_outlined);
              expect(vis, findsOneWidget);
              await tester.tap(vis);
              await tester.pumpAndSettle();
              // After tap: icon switches to visibility_off
              expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
            });

            testWidgets('Chips tab: FilterChip toggles selected state', (tester) async {
              app.main();
              await tester.pumpAndSettle();
              await tester.tap(find.text('Chips'));
              await tester.pumpAndSettle();

              // Tap Economy chip — should toggle to selected
              await tester.tap(find.text('Economy'));
              await tester.pumpAndSettle();
              expect(find.textContaining('Active: Economy'), findsOneWidget);
            });
          });
        }
    """)


# ══════════════════════════════════════════════════════════════════════════════
# FILE REGISTRY
# ══════════════════════════════════════════════════════════════════════════════

def _files(root: Path) -> list[tuple[Path, str]]:
    pkg = root / "packages"
    lib = root / "lib"
    fe  = lib / "features" / "component_showcase"
    uw  = pkg / "ui" / "lib" / "src" / "widgets"
    ck  = pkg / "core" / "lib" / "src"
    return [
        # Root
        (root / "pubspec.yaml",            _main_pubspec_yaml()),
        (root / "analysis_options.yaml",   _analysis_options_yaml()),
        (root / "README.md",               _readme_md()),
        (lib  / "main.dart",               _main_dart()),
        (fe   / "screens" / "component_showcase_screen.dart", _component_showcase_screen_dart()),

        # packages/core
        (pkg / "core" / "pubspec.yaml",                                       _core_pubspec_yaml()),
        (pkg / "core" / "analysis_options.yaml",                              "include: package:flutter_lints/flutter.yaml\n"),
        (pkg / "core" / "lib" / "core.dart",                                  _core_barrel_dart()),
        (ck  / "tokens" / "app_colors.dart",                                  _core_app_colors_dart()),
        (ck  / "tokens" / "app_typography.dart",                              _core_app_typography_dart()),
        (ck  / "tokens" / "app_spacing.dart",                                 _core_app_spacing_dart()),
        (ck  / "tokens" / "nomad_theme_extension.dart",                       _core_nomad_theme_extension_dart()),
        (ck  / "theme"  / "nomadair_theme.dart",                              _core_nomadair_theme_dart()),
        (ck  / "models" / "flight_model.dart",                                _core_flight_model_dart()),
        (ck  / "interfaces" / "flight_repository.dart",                       _core_flight_repository_dart()),

        # packages/ui
        (pkg / "ui" / "pubspec.yaml",                                         _ui_pubspec_yaml()),
        (pkg / "ui" / "analysis_options.yaml",                                "include: package:flutter_lints/flutter.yaml\n"),
        (pkg / "ui" / "lib" / "ui.dart",                                      _ui_barrel_dart()),
        (uw / "nomad_button.dart",                                            _ui_nomad_button_dart()),
        (uw / "nomad_card.dart",                                              _ui_nomad_card_dart()),
        (uw / "nomad_text_field.dart",                                        _ui_nomad_text_field_dart()),
        (uw / "nomad_chip.dart",                                              _ui_nomad_chip_dart()),

        # Tests
        (root / "test" / "unit"   / "variant_test.dart",         _unit_test_dart()),
        (root / "test" / "widget" / "components_test.dart",      _widget_test_dart()),
        (root / "integration_test" / "app_test.dart",            _integration_test_dart()),
    ]


# ══════════════════════════════════════════════════════════════════════════════
# GENERATION ENGINE
# ══════════════════════════════════════════════════════════════════════════════

def _write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    rel = path.relative_to(project_root())
    print(f"  WRITE    {str(rel):<72} {len(content):>6} B")


def _flutter_devices_json() -> list[dict]:
    import json
    r = subprocess.run(
        [FLUTTER_CMD, "devices", "--machine"],
        capture_output=True,
        text=True,
        check=False,
        cwd=str(SCRIPT_DIR),
        encoding="utf-8",
        errors="replace",
    )
    if r.returncode != 0:
        return []
    try:
        out = json.loads(r.stdout or "[]")
        return out if isinstance(out, list) else []
    except json.JSONDecodeError:
        return []


def resolve_android_device_id() -> str | None:
    """First connected Android emulator, else any Android device id."""
    devices = _flutter_devices_json()
    emulators = []
    android_other = []
    for d in devices:
        pid = (d.get("id") or "").strip()
        platform = (d.get("targetPlatform") or "").lower()
        if "android" not in platform:
            continue
        if "emulator" in pid or re.match(r"emulator-\d+", pid):
            emulators.append(pid)
        else:
            android_other.append(pid)
    if emulators:
        return emulators[0]
    if android_other:
        return android_other[0]
    return None


def warn_duplicate_emulator_processes() -> None:
    """Best-effort: warn if multiple QEMU instances may conflict with adb."""
    if HOST_OS != "Windows":
        return
    try:
        r = subprocess.run(
            ["tasklist", "/FI", "IMAGENAME eq qemu-system-x86_64.exe", "/FO", "CSV", "/NH"],
            capture_output=True,
            text=True,
            check=False,
            encoding="utf-8",
            errors="replace",
        )
        lines = [ln for ln in (r.stdout or "").splitlines() if ln.strip()]
        if len(lines) > 1:
            print(
                "\n  WARNING: Multiple QEMU (emulator) processes detected. "
                "Close extra emulators if adb shows duplicate or offline devices.",
            )
    except OSError:
        pass


def _assert_project() -> Path:
    root = project_root()
    if not root.exists():
        print("Run --generate first.")
        sys.exit(1)
    _validate_generated_files(root)
    return root


def generate_project() -> None:
    print(f"\n[NomadAir] Lesson {LESSON_NUMBER} — {LESSON_TITLE}")
    print("─" * 72)
    if not check_prerequisites():
        sys.exit(1)

    root = project_root()
    if root.exists():
        print(f"\n  ERROR: {root} already exists. Run --clean first.")
        sys.exit(1)

    print(f"\n[1/3] flutter create {PROJECT_NAME} ...")
    r = subprocess.run(
        [FLUTTER_CMD, "create", "--org", ORG_NAME,
         "--platforms", "android,ios", "--project-name", PROJECT_NAME, PROJECT_NAME],
        check=False, cwd=str(SCRIPT_DIR),
    )
    if r.returncode != 0:
        print("  ERROR: flutter create failed.")
        sys.exit(1)

    for ghost in [root / "test" / "widget_test.dart", root / "lib" / "main.dart"]:
        if ghost.exists():
            ghost.unlink()

    print("\n[2/3] Writing NomadAir source files ...")
    for path, content in _files(root):
        _write(path, content)

    print("\n[3/3] flutter pub get ...")
    subprocess.run([FLUTTER_CMD, "pub", "get"], check=True, cwd=str(root))

    _validate_generated_files(root)

    print("\n" + "─" * 72)
    print(f"[NomadAir] Generated: {root}")
    print()
    print("  Next steps:")
    print(f"    1. Open {PROJECT_NAME}/ in Android Studio")
    print("    2. Start Pixel 7 API 34 AVD")
    print("    3. python setup.py --run")
    print("    4. Explore all 4 tabs — tap, type, toggle chips")
    print()


# ══════════════════════════════════════════════════════════════════════════════
# CLI
# ══════════════════════════════════════════════════════════════════════════════

def cmd_generate(_): generate_project()

def cmd_run(_):
    root = _assert_project()
    warn_duplicate_emulator_processes()
    subprocess.run([FLUTTER_CMD, "pub", "get"], check=True, cwd=str(root))
    device = resolve_android_device_id()
    if not device:
        print("  No Android device or emulator found. Start an AVD or connect a device, then retry.")
        sys.exit(1)
    print(f"  Starting app on: {device}")
    subprocess.run([FLUTTER_CMD, "run", "-d", device], check=False, cwd=str(root))

def cmd_test(_):
    root = _assert_project()
    subprocess.run([FLUTTER_CMD, "test", "--reporter", "expanded"], check=False, cwd=str(root))

def cmd_demo(_): cmd_run(_)

def cmd_verify(_):
    root = _assert_project()
    r = subprocess.run(
        [FLUTTER_CMD, "test", "--reporter", "expanded"],
        capture_output=True, text=True, check=False, cwd=str(root),
    )
    out = r.stdout + r.stderr
    print("\n── Test Results " + "─" * 55)
    for line in out.splitlines():
        if any(k in line for k in ["PASS", "FAIL", "passed", "failed", "All tests", "Some tests"]):
            print(f"  {line.strip()}")
    print(f"\n  Exit: {r.returncode}  |  STATUS: {'PASS ✓' if r.returncode == 0 else 'FAIL ✗'}")

def cmd_clean(_):
    root = project_root()
    if not root.exists():
        print("Nothing to clean.")
        return

    def _on_rm_error(func, path, exc_info) -> None:
        try:
            os.chmod(path, 0o666)
            func(path)
        except OSError:
            pass

    try:
        shutil.rmtree(root, onerror=_on_rm_error)
    except TypeError:
        shutil.rmtree(root)
    print(f"Deleted {root}")

def cmd_ios(_):
    if HOST_OS != "Darwin": print("iOS requires macOS."); sys.exit(1)
    root = _assert_project()
    subprocess.run([FLUTTER_CMD, "run", "-d", "booted"], check=False, cwd=str(root))


def main() -> None:
    parser = argparse.ArgumentParser(
        description=f"NomadAir Lesson {LESSON_NUMBER} — {LESSON_TITLE}",
    )
    g = parser.add_mutually_exclusive_group(required=True)
    for flag in ("generate", "run", "test", "demo", "verify", "clean", "ios"):
        g.add_argument(f"--{flag}", action="store_true")
    args = parser.parse_args()

    for name, fn in [("generate", cmd_generate), ("run", cmd_run), ("test", cmd_test),
                     ("demo", cmd_demo), ("verify", cmd_verify),
                     ("clean", cmd_clean), ("ios", cmd_ios)]:
        if getattr(args, name):
            fn(args); return


if __name__ == "__main__":
    main()

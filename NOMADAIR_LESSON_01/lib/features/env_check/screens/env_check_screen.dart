// ignore_for_file: avoid_print
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/env_check_result.dart';
import '../widgets/check_tile.dart';

/// NomadAir Lesson 01 — Lesson Visualizer.
///
/// Runs seven live platform checks and renders each result in real time.
/// The log panel at the bottom records every state transition with
/// a millisecond-precision timestamp.
final class EnvCheckScreen extends StatefulWidget {
  const EnvCheckScreen({super.key});

  @override
  State<EnvCheckScreen> createState() => _EnvCheckScreenState();
}

final class _EnvCheckScreenState extends State<EnvCheckScreen> {
  // ── Check Definitions ──────────────────────────────────────
  static const List<(String, String)> _defs = [
    ('Platform Target',   'Confirm running on Android or iOS'),
    ('Screen Dimensions', 'Minimum 360 × 640 dp for NomadAir layouts'),
    ('Dart Runtime',      'Dart 3.x required for sealed classes'),
    ('Device Info',       'OS version from device_info_plus'),
    ('Package Info',      'App name + build via package_info_plus'),
    ('Material 3',        'useMaterial3 must be true in ThemeData'),
    ('Dark Mode',         'System brightness is detectable'),
  ];

  final List<EnvCheckResult> _results = [];
  final List<String> _log = [];
  bool _running = false;
  bool _hasRun  = false;

  @override
  void initState() {
    super.initState();
    _resetResults();
  }

  void _resetResults() {
    _results
      ..clear()
      ..addAll(
        _defs.map((d) => CheckPending(name: d.$1, description: d.$2)),
      );
  }

  void _log_(String msg) {
    final ts = DateTime.now().toIso8601String().substring(11, 23);
    if (mounted) setState(() => _log.add('[$ts] $msg'));
  }

  // ── Check Execution ────────────────────────────────────────

  Future<void> _runChecks() async {
    if (_running) return;
    setState(() {
      _running = true;
      _hasRun  = true;
      _log.clear();
      _resetResults();
    });
    _log_('Verification started.');

    await _exec(0, _checkPlatform);
    await _exec(1, _checkScreen);
    await _exec(2, _checkDart);
    await _exec(3, _checkDeviceInfo);
    await _exec(4, _checkPackageInfo);
    await _exec(5, _checkMaterial3);
    await _exec(6, _checkDarkMode);

    if (!mounted) return;
    final pass = _results.whereType<CheckPassing>().length;
    final fail = _results.whereType<CheckFailing>().length;
    _log_('Done — $pass passed, $fail failed.');
    setState(() => _running = false);
  }

  Future<void> _exec(
    int i,
    Future<EnvCheckResult> Function() fn,
  ) async {
    if (!mounted) return;
    setState(() => _results[i] = CheckRunning(
      name: _defs[i].$1,
      description: _defs[i].$2,
    ));
    _log_('Checking: ${_defs[i].$1}...');
    await Future<void>.delayed(const Duration(milliseconds: 280));

    final result = await fn();
    final status = switch (result) {
      CheckPassing(value: final v) => 'PASS — $v',
      CheckFailing(error: final e) => 'FAIL — $e',
      _ => '?',
    };
    _log_('  ${_defs[i].$1}: $status');
    if (mounted) setState(() => _results[i] = result);
  }

  // ── Individual Checks ──────────────────────────────────────

  Future<EnvCheckResult> _checkPlatform() async {
    final isAndroid = Platform.isAndroid;
    final isIOS     = Platform.isIOS;
    if (!isAndroid && !isIOS) {
      return CheckFailing(
        name: _defs[0].$1,
        description: _defs[0].$2,
        error: 'Running on ${Platform.operatingSystem} — not a mobile target',
        fix: 'Run on Android AVD or iOS Simulator',
      );
    }
    return CheckPassing(
      name: _defs[0].$1,
      description: _defs[0].$2,
      value: Platform.operatingSystem.toUpperCase(),
    );
  }

  Future<EnvCheckResult> _checkScreen() async {
    if (!mounted) {
      return CheckPending(name: _defs[1].$1, description: _defs[1].$2);
    }
    final size = MediaQuery.sizeOf(context);
    const minW = 360.0;
    const minH = 640.0;
    if (size.width < minW || size.height < minH) {
      return CheckFailing(
        name: _defs[1].$1,
        description: _defs[1].$2,
        error:
            '${size.width.toInt()} x ${size.height.toInt()} dp — below minimum',
        fix: 'Use Pixel 7 AVD (393 x 851 dp) or larger',
      );
    }
    return CheckPassing(
      name: _defs[1].$1,
      description: _defs[1].$2,
      value: '${size.width.toInt()} x ${size.height.toInt()} dp',
    );
  }

  Future<EnvCheckResult> _checkDart() async {
    final full    = Platform.version;
    final semver  = full.split(' ').firstOrNull ?? full;
    final major   = int.tryParse(semver.split('.').firstOrNull ?? '0') ?? 0;
    if (major < 3) {
      return CheckFailing(
        name: _defs[2].$1,
        description: _defs[2].$2,
        error: 'Dart $semver detected — Dart 3.x required',
        fix: 'Run: flutter upgrade',
      );
    }
    return CheckPassing(
      name: _defs[2].$1,
      description: _defs[2].$2,
      value: 'Dart $semver',
    );
  }

  Future<EnvCheckResult> _checkDeviceInfo() async {
    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await plugin.androidInfo;
        return CheckPassing(
          name: _defs[3].$1,
          description: _defs[3].$2,
          value:
              'Android ${info.version.release}'
              ' (API ${info.version.sdkInt})'
              ' · ${info.model}',
        );
      }
      if (Platform.isIOS) {
        final info = await plugin.iosInfo;
        return CheckPassing(
          name: _defs[3].$1,
          description: _defs[3].$2,
          value: '${info.systemName} ${info.systemVersion} · ${info.utsname.machine}',
        );
      }
      return CheckFailing(
        name: _defs[3].$1,
        description: _defs[3].$2,
        error: 'Unsupported platform',
        fix: 'Run on Android or iOS target',
      );
    } catch (e) {
      return CheckFailing(
        name: _defs[3].$1,
        description: _defs[3].$2,
        error: e.toString().substring(0, 60),
        fix: 'Run flutter pub get and rebuild',
      );
    }
  }

  Future<EnvCheckResult> _checkPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return CheckPassing(
        name: _defs[4].$1,
        description: _defs[4].$2,
        value: '${info.appName} v${info.version}+${info.buildNumber}',
      );
    } catch (e) {
      return CheckFailing(
        name: _defs[4].$1,
        description: _defs[4].$2,
        error: e.toString().substring(0, 60),
        fix: 'Ensure package_info_plus is in pubspec.yaml',
      );
    }
  }

  Future<EnvCheckResult> _checkMaterial3() async {
    if (!mounted) {
      return CheckPending(name: _defs[5].$1, description: _defs[5].$2);
    }
    final isM3 = Theme.of(context).useMaterial3;
    if (!isM3) {
      return CheckFailing(
        name: _defs[5].$1,
        description: _defs[5].$2,
        error: 'useMaterial3 is false',
        fix: 'Set useMaterial3: true in ThemeData',
      );
    }
    final seed = Theme.of(context)
        .colorScheme
        .primary
        .value
        .toRadixString(16)
        .toUpperCase()
        .padLeft(8, '0');
    return CheckPassing(
      name: _defs[5].$1,
      description: _defs[5].$2,
      value: 'M3 active — seed #$seed',
    );
  }

  Future<EnvCheckResult> _checkDarkMode() async {
    if (!mounted) {
      return CheckPending(name: _defs[6].$1, description: _defs[6].$2);
    }
    final brightness = MediaQuery.platformBrightnessOf(context);
    return CheckPassing(
      name: _defs[6].$1,
      description: _defs[6].$2,
      value: 'System brightness: ${brightness.name.toUpperCase()}',
    );
  }

  void _injectFailure() {
    setState(() {
      _results[1] = const CheckFailing(
        name: 'Screen Dimensions',
        description: 'Minimum 360 x 640 dp for NomadAir layouts',
        error: '320 x 480 dp — below minimum (simulated)',
        fix: 'Use Pixel 7 AVD (393 x 851 dp) or larger',
      );
      _log.add('[INJECTED] Screen Dimensions: FAIL (simulated)');
    });
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final passed  = _results.whereType<CheckPassing>().length;
    final failed  = _results.whereType<CheckFailing>().length;
    final pending = _results.whereType<CheckPending>().length +
        _results.whereType<CheckRunning>().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NomadAir — Env Check'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // ── Status bar ────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: _hasRun
                ? (failed == 0
                    ? AppColors.success.withAlpha(26)
                    : AppColors.error.withAlpha(26))
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Badge(label: 'Pending', count: pending, color: Colors.grey),
                _Badge(label: 'Passed',  count: passed,  color: AppColors.success),
                _Badge(label: 'Failed',  count: failed,  color: AppColors.error),
              ],
            ),
          ),
          // ── Check list ────────────────────────────────────
          Expanded(
            flex: 3,
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _results.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) => CheckTile(result: _results[i]),
            ),
          ),
          // ── Log panel ─────────────────────────────────────
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.xs,
                    ),
                    child: Text(
                      'LOG',
                      style: AppTypography.monoSmall.copyWith(
                        color: const Color(0xFF58A6FF),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFF30363D)),
                  Expanded(
                    child: _log.isEmpty
                        ? const Center(
                            child: Text(
                              'Tap "Run Checks" to begin.',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                color: Color(0xFF8B949E),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            itemCount: _log.length,
                            itemBuilder: (_, i) => Text(
                              _log[i],
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: Color(0xFFC9D1D9),
                                height: 1.6,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // ── Action buttons ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: Column(
              children: [
                Semantics(
                  label: 'Run all environment checks',
                  child: FilledButton(
                    onPressed: _running ? null : _runChecks,
                    child: _running
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Running Checks...'),
                            ],
                          )
                        : const Text('Run Checks'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Semantics(
                  label: 'Simulate a screen dimensions failure',
                  child: OutlinedButton(
                    onPressed: _running ? null : _injectFailure,
                    child: const Text('Inject Failure'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widget ──────────────────────────────────────────────────────

final class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int    count;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$count $label',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: AppTypography.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

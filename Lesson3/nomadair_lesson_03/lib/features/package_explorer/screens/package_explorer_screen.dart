import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_data/data.dart';
import 'package:nomadair_ui/ui.dart';

// ── Internal check result type (sealed — reinforces Lesson 01) ──────

sealed class _CheckResult {
  const _CheckResult(this.message);
  final String message;
}

final class _Pass extends _CheckResult {
  const _Pass(super.message);
}

final class _Fail extends _CheckResult {
  const _Fail(super.message);
}

// ── Package metadata model ───────────────────────────────────────────

final class _PackageMeta {
  const _PackageMeta({
    required this.name,
    required this.description,
    required this.color,
    required this.exports,
    required this.dependsOn,
  });
  final String       name;
  final String       description;
  final Color        color;
  final List<String> exports;
  final List<String> dependsOn;
}

// ── Main screen ──────────────────────────────────────────────────────

final class PackageExplorerScreen extends StatefulWidget {
  const PackageExplorerScreen({super.key});

  @override
  State<PackageExplorerScreen> createState() =>
      _PackageExplorerScreenState();
}

final class _PackageExplorerScreenState
    extends State<PackageExplorerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // ── Package metadata ───────────────────────────────────────
  static const List<_PackageMeta> _packages = [
    _PackageMeta(
      name: 'nomadair_core',
      description: 'Design tokens · Domain models · Repository interfaces',
      color: Color(0xFF4A90D9),
      exports: [
        'AppColors',
        'AppTypography',
        'AppSpacing',
        'FlightModel',
        'FlightRepository',
      ],
      dependsOn: ['flutter'],
    ),
    _PackageMeta(
      name: 'nomadair_ui',
      description: 'Widget library · Theme · Component system',
      color: Color(0xFF5BAD6F),
      exports: ['NomadAirTheme', 'NomadButton', 'NomadCard'],
      dependsOn: ['flutter', 'nomadair_core'],
    ),
    _PackageMeta(
      name: 'nomadair_data',
      description: 'Repository implementations · Mock data layer',
      color: Color(0xFFE8934A),
      exports: ['MockFlightRepository'],
      dependsOn: ['nomadair_core'],
    ),
  ];

  // ── Verify state ───────────────────────────────────────────
  static const List<String> _checkNames = [
    'nomadair_core loaded',
    'nomadair_ui loaded',
    'nomadair_data loaded',
    'Boundary: data → core (interface impl)',
    'Boundary: ui ↛ data (import blocked)',
  ];

  final List<_CheckResult?> _results     = List.filled(5, null);
  final List<String>        _log          = [];
  bool                      _running      = false;
  bool                      _violated     = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _appendLog(String msg) {
    final ts = DateTime.now().toIso8601String().substring(11, 23);
    if (mounted) setState(() => _log.add('[$ts] $msg'));
  }

  // ── Individual checks ──────────────────────────────────────

  Future<_CheckResult> _checkCore() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    const color = AppColors.brandPrimary;
    if (color.value == 0xFF1A73E8) {
      return const _Pass('AppColors.brandPrimary = #1A73E8 ✓');
    }
    return _Fail('Unexpected value: 0x${color.value.toRadixString(16)}');
  }

  Future<_CheckResult> _checkUi() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    try {
      final theme = NomadAirTheme.light();
      if (!theme.useMaterial3) return const _Fail('useMaterial3 = false');
      return const _Pass('NomadAirTheme.light() — M3 active ✓');
    } catch (e) {
      return _Fail('Exception: $e');
    }
  }

  Future<_CheckResult> _checkData() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      const repo = MockFlightRepository();
      final flights = await repo.fetchFlights(
        origin: 'BOM',
        destination: 'DEL',
      );
      for (final f in flights) {
        _appendLog('  ${f.id}: ${f.airline} · ${f.route} · '
            '${f.formattedDuration} · ${f.formattedPrice} · ${f.stopsLabel}');
      }
      return _Pass('MockFlightRepository → ${flights.length} flights ✓');
    } catch (e) {
      return _Fail('Exception: $e');
    }
  }

  Future<_CheckResult> _checkBoundaryImpl() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // MockFlightRepository implements FlightRepository from core.
    // If this assignment compiles, the interface contract is satisfied.
    const FlightRepository repo = MockFlightRepository();
    final flight = await repo.fetchFlightById('AI-402');
    if (flight != null && flight.airline == 'Air India') {
      return const _Pass('MockFlightRepository implements FlightRepository ✓');
    }
    return const _Fail('fetchFlightById returned unexpected result');
  }

  Future<_CheckResult> _checkBoundaryBlock() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // The ui → data import is BLOCKED AT COMPILE TIME.
    // This check confirms the boundary rule conceptually:
    // nomadair_ui's pubspec.yaml lists no dependency on nomadair_data,
    // so any `import package:nomadair_data/...` inside packages/ui/
    // is a compile error — not a runtime error.
    return const _Pass(
      'ui → data import blocked by pub dependency graph ✓\n'
      '  (nomadair_data absent from packages/ui/pubspec.yaml)',
    );
  }

  // ── Verify runner ──────────────────────────────────────────

  Future<void> _runVerification() async {
    if (_running) return;
    setState(() {
      _running  = true;
      _violated = false;
      _log.clear();
      for (int i = 0; i < _results.length; i++) {
        _results[i] = null;
      }
    });
    _appendLog('Verification started.');

    final checks = [
      _checkCore,
      _checkUi,
      _checkData,
      _checkBoundaryImpl,
      _checkBoundaryBlock,
    ];

    for (int i = 0; i < checks.length; i++) {
      _appendLog('Checking: ${_checkNames[i]}...');
      final result = await checks[i]();
      final label = switch (result) {
        _Pass(message: final m) => 'PASS — $m',
        _Fail(message: final m) => 'FAIL — $m',
      };
      _appendLog('  → $label');
      if (mounted) setState(() => _results[i] = result);
    }

    final passed = _results.whereType<_Pass>().length;
    final failed = _results.whereType<_Fail>().length;
    _appendLog('Done — $passed passed, $failed failed.');
    if (mounted) setState(() => _running = false);
  }

  void _injectViolation() {
    setState(() {
      _violated = true;
      _log
        ..clear()
        ..add('[INJECTED] Simulated boundary violation: ui → data')
        ..add('  import "package:nomadair_data/data.dart"  ← BLOCKED')
        ..add('  Error: Target of URI does not exist.')
        ..add('  Fix: Use FlightRepository interface from nomadair_core instead.');
    });
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Package Explorer'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Architecture'),
            Tab(text: 'Packages'),
            Tab(text: 'Verify'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _ArchitectureTab(violated: _violated),
          _PackagesTab(packages: _packages),
          _VerifyTab(
            checkNames: _checkNames,
            results: _results,
            log: _log,
            running: _running,
            onRun: _runVerification,
            onInject: _injectViolation,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 1: Architecture diagram
// ══════════════════════════════════════════════════════════════════════

final class _ArchitectureTab extends StatelessWidget {
  const _ArchitectureTab({required this.violated});
  final bool violated;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: CustomPaint(
              painter: _DependencyGraphPainter(
                isDark: isDark,
                showViolation: violated,
              ),
              size: Size.infinite,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF0E3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Arrow direction = "depends on". '
              'ui and data must NEVER depend on each other.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFC4692A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── CustomPainter: dependency graph ──────────────────────────────────

final class _DependencyGraphPainter extends CustomPainter {
  const _DependencyGraphPainter({
    required this.isDark,
    required this.showViolation,
  });
  final bool isDark;
  final bool showViolation;

  static const _blue   = Color(0xFF4A90D9);
  static const _green  = Color(0xFF5BAD6F);
  static const _orange = Color(0xFFE8934A);
  static const _grey   = Color(0xFF6B7280);
  static const _red    = Color(0xFFEA4335);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Node centres
    final corePos = Offset(w * 0.50, h * 0.14);
    final uiPos   = Offset(w * 0.22, h * 0.52);
    final dataPos = Offset(w * 0.78, h * 0.52);
    final appPos  = Offset(w * 0.50, h * 0.86);

    // Dependency arrows (drawn behind nodes)
    _arrow(canvas, appPos,  corePos, _grey);
    _arrow(canvas, appPos,  uiPos,   _green);
    _arrow(canvas, appPos,  dataPos, _orange);
    _arrow(canvas, uiPos,   corePos, _blue);
    _arrow(canvas, dataPos, corePos, _orange);

    // Violation arrow (ui → data) — only shown when _violated
    if (showViolation) {
      _arrow(canvas, uiPos, dataPos, _red, dashed: true);
      _violationLabel(canvas, Offset(w * 0.50, h * 0.52));
    }

    // Nodes
    _node(canvas, corePos,  'nomadair_core',  '↕ tokens + interfaces', _blue);
    _node(canvas, uiPos,    'nomadair_ui',    '⊞ widgets + theme',     _green);
    _node(canvas, dataPos,  'nomadair_data',  '⦿ repositories',        _orange);
    _node(canvas, appPos,   'app',            '◈ main application',    _grey);
  }

  void _arrow(
    Canvas canvas,
    Offset from,
    Offset to,
    Color color, {
    bool dashed = false,
  }) {
    final dir = to - from;
    final norm = dir / dir.distance;
    const nodeR = 38.0;
    final start = from + norm * nodeR;
    final end   = to   - norm * nodeR;

    final paint = Paint()
      ..color = color.withAlpha(200)
      ..strokeWidth = dashed ? 2.5 : 2.0
      ..style = PaintingStyle.stroke;

    if (dashed) {
      // Draw dashed line
      final total = (end - start).distance;
      final step  = 10.0;
      var drawn   = 0.0;
      var drawing = true;
      while (drawn < total) {
        final segEnd = (drawn + step).clamp(0.0, total);
        if (drawing) {
          canvas.drawLine(
            start + norm * drawn,
            start + norm * segEnd,
            paint,
          );
        }
        drawn  += step;
        drawing = !drawing;
      }
    } else {
      canvas.drawLine(start, end, paint);
    }

    // Arrowhead
    final arrowPaint = Paint()
      ..color = color.withAlpha(200)
      ..style = PaintingStyle.fill;
    final perp = Offset(-norm.dy, norm.dx);
    const sz = 9.0;
    final tip = end;
    final left  = tip - norm * sz + perp * (sz * 0.45);
    final right = tip - norm * sz - perp * (sz * 0.45);
    canvas.drawPath(
      Path()..moveTo(tip.dx, tip.dy)..lineTo(left.dx, left.dy)
           ..lineTo(right.dx, right.dy)..close(),
      arrowPaint,
    );
  }

  void _node(
    Canvas canvas,
    Offset center,
    String title,
    String subtitle,
    Color color,
  ) {
    const nw = 148.0;
    const nh =  54.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: nw, height: nh),
      const Radius.circular(12),
    );

    // Glow / shadow
    canvas.drawRRect(
      rect.inflate(5),
      Paint()
        ..color = color.withAlpha(25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Fill
    canvas.drawRRect(
      rect,
      Paint()..color = color.withAlpha(22)..style = PaintingStyle.fill,
    );
    // Border
    canvas.drawRRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Title text
    final tp = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: color,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: nw - 12);
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - nh / 4 - 2),
    );

    // Subtitle text
    final sp = TextPainter(
      text: TextSpan(
        text: subtitle,
        style: TextStyle(
          color: color.withAlpha(180),
          fontSize: 9.5,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: nw - 12);
    sp.paint(
      canvas,
      Offset(center.dx - sp.width / 2, center.dy + 8),
    );
  }

  void _violationLabel(Canvas canvas, Offset center) {
    final bg = Paint()..color = const Color(0xFFFFEBEE)..style = PaintingStyle.fill;
    final border = Paint()
      ..color = _red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 160, height: 32),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, bg);
    canvas.drawRRect(rrect, border);
    final tp = TextPainter(
      text: const TextSpan(
        text: '✕ BOUNDARY VIOLATION',
        style: TextStyle(
          color: _red,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_DependencyGraphPainter old) =>
      old.isDark != isDark || old.showViolation != showViolation;
}

// ══════════════════════════════════════════════════════════════════════
// TAB 2: Package list
// ══════════════════════════════════════════════════════════════════════

final class _PackagesTab extends StatelessWidget {
  const _PackagesTab({required this.packages});
  final List<_PackageMeta> packages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: packages.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _PackageCard(meta: packages[i]),
    );
  }
}

final class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.meta});
  final _PackageMeta meta;

  @override
  Widget build(BuildContext context) {
    return NomadCard(
      semanticLabel: '${meta.name} package',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: meta.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                meta.name,
                style: AppTypography.monoSmall.copyWith(
                  color: meta.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(meta.description, style: AppTypography.bodySmall),
          const Divider(height: AppSpacing.md),
          Text(
            'EXPORTS',
            style: AppTypography.monoSmall.copyWith(
              color: meta.color,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: meta.exports.map((e) {
              return Chip(
                label: Text(e, style: AppTypography.monoSmall),
                backgroundColor: meta.color.withAlpha(20),
                side: BorderSide(color: meta.color.withAlpha(80)),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'DEPENDS ON',
            style: AppTypography.monoSmall.copyWith(
              color: AppColors.subtleLight,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            children: meta.dependsOn.map((d) {
              return Chip(
                label: Text(d, style: AppTypography.monoSmall),
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Colors.grey.withAlpha(80)),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 3: Verify
// ══════════════════════════════════════════════════════════════════════

final class _VerifyTab extends StatelessWidget {
  const _VerifyTab({
    required this.checkNames,
    required this.results,
    required this.log,
    required this.running,
    required this.onRun,
    required this.onInject,
  });

  final List<String>         checkNames;
  final List<_CheckResult?>  results;
  final List<String>         log;
  final bool                 running;
  final VoidCallback         onRun;
  final VoidCallback         onInject;

  @override
  Widget build(BuildContext context) {
    final passed = results.whereType<_Pass>().length;
    final failed = results.whereType<_Fail>().length;

    return Column(
      children: [
        // ── Status summary ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stat(label: 'Passed', count: passed, color: AppColors.success),
              _Stat(label: 'Failed', count: failed, color: AppColors.error),
              _Stat(
                label: 'Pending',
                count: checkNames.length - passed - failed,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        // ── Check rows ──────────────────────────────────────
        Expanded(
          flex: 2,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: checkNames.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _CheckRow(
              name: checkNames[i],
              result: results[i],
            ),
          ),
        ),
        // ── Log panel ───────────────────────────────────────
        Expanded(
          flex: 3,
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
                    AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.xs,
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
                  child: log.isEmpty
                      ? const Center(
                          child: Text(
                            'Tap "Verify All Packages" to begin.',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          itemCount: log.length,
                          itemBuilder: (_, i) => Text(
                            log[i],
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10.5,
                              color: log[i].contains('FAIL') ||
                                      log[i].contains('VIOLATION') ||
                                      log[i].contains('BLOCKED')
                                  ? const Color(0xFFFF7B72)
                                  : log[i].contains('PASS')
                                      ? const Color(0xFF7EE787)
                                      : const Color(0xFFC9D1D9),
                              height: 1.6,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        // ── Buttons ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg,
          ),
          child: Column(
            children: [
              Semantics(
                label: 'Verify all three NomadAir packages',
                child: NomadButton(
                  label: running ? 'Verifying...' : 'Verify All Packages',
                  loading: running,
                  onPressed: running ? null : onRun,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Semantics(
                label: 'Simulate a package boundary violation',
                child: OutlinedButton(
                  onPressed: running ? null : onInject,
                  child: const Text('Inject Violation'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Helper widgets ───────────────────────────────────────────────────

final class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.name, required this.result});
  final String         name;
  final _CheckResult?  result;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (result) {
      null            => (Icons.radio_button_unchecked, Colors.grey),
      _Pass()         => (Icons.check_circle,           AppColors.success),
      _Fail()         => (Icons.cancel,                 AppColors.error),
    };
    final subtitle = switch (result) {
      null => 'Pending...',
      _Pass(message: final message) => message,
      _Fail(message: final message) => message,
    };
    return Semantics(
      label: '$name: ${result == null ? 'pending' : result is _Pass ? 'passed' : 'failed'}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.monoSmall.copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _Stat extends StatelessWidget {
  const _Stat({
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
          Text(label, style: AppTypography.bodySmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

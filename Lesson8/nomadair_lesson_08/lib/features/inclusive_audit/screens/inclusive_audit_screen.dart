import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../core/services/accessibility_audit.dart';

/// Lesson 08 Visualizer — Inclusive Audit Screen.
///
/// Three tabs:
///   Components : all NomadAir widgets with semantic overlay + touch-target badges
///   Audit      : live AccessibilityAudit run (12 checks)
///   Gestures   : TalkBack gesture simulator
final class InclusiveAuditScreen extends StatefulWidget {
  const InclusiveAuditScreen({super.key});

  @override
  State<InclusiveAuditScreen> createState() => _InclusiveAuditScreenState();
}

final class _InclusiveAuditScreenState extends State<InclusiveAuditScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  int _selectedNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(_syncNavWithTab);
  }

  @override
  void dispose() {
    _tab.removeListener(_syncNavWithTab);
    _tab.dispose();
    super.dispose();
  }

  void _syncNavWithTab() {
    if (!mounted || _tab.indexIsChanging) return;
    final mapped = switch (_tab.index) { 0 => 0, 1 => 1, _ => 2 };
    if (_selectedNavIndex != mapped) {
      setState(() => _selectedNavIndex = mapped);
    }
  }

  void _onBottomNavTap(int index) {
    if (index <= 2) {
      setState(() => _selectedNavIndex = index);
      _tab.animateTo(index);
      return;
    }
    setState(() => _selectedNavIndex = index);
    final label = index == 3 ? 'Bookings' : 'Profile';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label is not part of Lesson 08 demo yet.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 86,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Inclusive Design Audit'),
            Text(
              'NomadAir Masterclass • Lesson 08',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        actions: [
          Semantics(
            label: 'About inclusive design audit',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'About',
              onPressed: () => showAboutDialog(
                context: context,
                applicationName: 'Inclusive Design Audit',
                applicationVersion: 'Lesson 08',
                children: const [
                  Text(
                    'Live accessibility checks for semantics, roles, and '
                    'minimum touch targets.',
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Components'),
            Tab(text: 'Audit'),
            Tab(text: 'Gestures'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _ComponentsTab(),
          _AuditTab(),
          _GesturesTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavIndex,
        onDestinationSelected: _onBottomNavTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            label: 'Discovery',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 1: Components — semantic overlay visualizer
// ══════════════════════════════════════════════════════════════════════

final class _ComponentsTab extends StatefulWidget {
  const _ComponentsTab();

  @override
  State<_ComponentsTab> createState() => _ComponentsTabState();
}

final class _ComponentsTabState extends State<_ComponentsTab> {
  bool _showOverlay = true;
  bool _filterSelected = false;
  bool _buttonLoading = false;

  Future<void> _triggerLoad() async {
    setState(() => _buttonLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _buttonLoading = false);
  }

  static const FlightModel _mockFlight = FlightModel(
    id: 'AI-101', airline: 'Air India',
    origin: 'BOM', destination: 'DEL',
    durationMinutes: 125, priceInr: 4200, stops: 0,
  );

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Column(
      children: [
        // Overlay toggle
        Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(Icons.accessibility_new,
                  size: 16, color: AppColors.semanticOverlay),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text('Semantic Overlay',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.semanticOverlay)),
              const Spacer(),
              Semantics(
                label: 'Toggle semantic overlay',
                child: Switch(
                  value: _showOverlay,
                  onChanged: (_) => setState(() => _showOverlay = !_showOverlay),
                  activeColor: AppColors.semanticOverlay,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                'Components Overview',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.semanticOverlay,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'All NomadAir components with semantic labels, roles,\n'
                'and touch target size verification.',
                style: AppTypography.bodyMedium.copyWith(color: t.onSurfaceColor),
              ),
              const SizedBox(height: AppSpacing.md),
              _ComponentOverviewCard(
                showOverlay: _showOverlay,
                semanticLabel: '"Search flights", button',
                title: 'NomadButton',
                role: 'Button',
                description: '"Search flights"',
                preview: NomadButton(
                  label: 'Search Flights',
                  loading: _buttonLoading,
                  onPressed: _triggerLoad,
                ),
              ),
              _ComponentOverviewCard(
                showOverlay: _showOverlay,
                semanticLabel: _mockFlight.accessibilityLabel,
                title: 'NomadCard',
                role: 'Button',
                description: 'Air India, BOM to DEL,\n4200 rupees, Non-stop,\n2 hours 5 minutes',
                preview: NomadFlightCard(flight: _mockFlight, onTap: () {}),
              ),
              _ComponentOverviewCard(
                showOverlay: _showOverlay,
                semanticLabel: '"From city", textField',
                title: 'NomadTextField',
                role: 'Text field',
                description: 'From city',
                preview: const NomadTextField(
                  label: 'From',
                  hint: 'Mumbai (BOM)',
                  prefixIcon: Icons.pin_drop_outlined,
                ),
              ),
              _ComponentOverviewCard(
                showOverlay: _showOverlay,
                semanticLabel: '"Non-stop", selected',
                title: 'NomadChip',
                role: 'Selected',
                description: 'Non-stop',
                preview: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    NomadChip(
                      label: 'Non-stop',
                      variant: const FilterChipVariant(),
                      selected: true,
                      onTap: () => setState(
                        () => _filterSelected = !_filterSelected,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    NomadChip(
                      label: _filterSelected ? '1 Stop' : 'Search',
                      icon: _filterSelected ? null : Icons.search,
                      variant: const ActionChipVariant(),
                      onTap: () => setState(
                        () => _filterSelected = !_filterSelected,
                      ),
                    ),
                  ],
                ),
              ),
              _ComponentOverviewCard(
                showOverlay: _showOverlay,
                semanticLabel: 'Destination image: Dubai skyline at sunset',
                title: 'DestCard Image',
                role: 'Image',
                description: 'Destination image:\nDubai skyline at sunset',
                preview: Container(
                  height: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF684CF5), Color(0xFFFF9F6E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              _ComponentOverviewCard(
                showOverlay: _showOverlay,
                semanticLabel: '4200 rupees, price updated',
                title: 'Price Ticker',
                role: 'Live region',
                description: '4200 rupees, price updated',
                preview: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: t.surfaceColor,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹4,200 ↗',
                        style: AppTypography.headlineSmall.copyWith(
                          color: t.onSurfaceColor,
                        ),
                      ),
                      Text(
                        'Live price • Updated now',
                        style: AppTypography.bodySmall.copyWith(
                          color: t.onSurfaceColor.withAlpha(170),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}

// ── SemanticBox: wraps any widget with a teal overlay showing semantic info ─

final class _SemanticBox extends StatelessWidget {
  const _SemanticBox({
    required this.child,
    required this.label,
    required this.touchW,
    required this.touchH,
    required this.showOverlay,
  });

  final Widget child;
  final String label;
  final double touchW, touchH;
  final bool   showOverlay;

  @override
  Widget build(BuildContext context) {
    final passes = touchW >= AppSpacing.minTouchTarget &&
        touchH >= AppSpacing.minTouchTarget;
    final badgeColor = passes ? AppColors.green500 : AppColors.red500;
    final teal = AppColors.semanticOverlay;

    if (!showOverlay) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Component
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: teal, width: 1.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
          ),
          child: child,
        ),
        // Touch-target badge
        Positioned(
          top: -10, right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              passes ? '✓ 48dp' : '✗ <48dp',
              style: AppTypography.monoSmall.copyWith(
                color: AppColors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        // Semantic label chip
        Positioned(
          bottom: -10, left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.semanticOverlayLight,
              border: Border.all(color: teal.withAlpha(120)),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text(
              label,
              style: AppTypography.monoSmall.copyWith(
                color: teal,
                fontSize: 9,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

final class _ComponentOverviewCard extends StatelessWidget {
  const _ComponentOverviewCard({
    required this.preview,
    required this.semanticLabel,
    required this.title,
    required this.role,
    required this.description,
    required this.showOverlay,
  });

  final Widget preview;
  final String semanticLabel;
  final String title;
  final String role;
  final String description;
  final bool showOverlay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: _SemanticBox(
        label: semanticLabel,
        touchW: double.infinity,
        touchH: AppSpacing.minTouchTarget,
        showOverlay: showOverlay,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 520;
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      preview,
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        title,
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(role, style: AppTypography.bodyMedium),
                      const SizedBox(height: 2),
                      Text(description, style: AppTypography.bodySmall),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: preview),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.headlineSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(role, style: AppTypography.bodyMedium),
                          const SizedBox(height: 2),
                          Text(description, style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 2: Audit — live AccessibilityAudit run
// ══════════════════════════════════════════════════════════════════════

final class _AuditTab extends StatefulWidget {
  const _AuditTab();

  @override
  State<_AuditTab> createState() => _AuditTabState();
}

final class _AuditTabState extends State<_AuditTab> {
  final _audit = const DefaultAccessibilityAudit();
  List<AuditResult> _results = [];
  bool _running = false;
  bool _hasRun  = false;

  static final List<AuditTarget> _targets = [
    const AuditTarget(name:'NomadButton (Filled)',semanticLabel:'Book Flight',
      touchTargetWidth:double.infinity,touchTargetHeight:AppSpacing.minTouchTarget,hasSemanticRole:true),
    const AuditTarget(name:'NomadButton (Outlined)',semanticLabel:'Save Trip',
      touchTargetWidth:double.infinity,touchTargetHeight:AppSpacing.minTouchTarget,hasSemanticRole:true),
    const AuditTarget(name:'NomadButton (Ghost)',semanticLabel:'Cancel',
      touchTargetWidth:double.infinity,touchTargetHeight:AppSpacing.minTouchTarget,hasSemanticRole:true),
    const AuditTarget(name:'NomadCard (ElevatedCard)',semanticLabel:'Flight card content',
      touchTargetWidth:double.infinity,touchTargetHeight:AppSpacing.minTouchTarget,hasSemanticRole:true),
    const AuditTarget(name:'NomadFlightCard',semanticLabel:'Air India, BOM → DEL, ₹4200',
      touchTargetWidth:double.infinity,touchTargetHeight:96,hasSemanticRole:true),
    const AuditTarget(name:'NomadTextField (default)',semanticLabel:'Departure City',
      touchTargetWidth:double.infinity,touchTargetHeight:AppSpacing.minTouchTarget,hasSemanticRole:true),
    const AuditTarget(name:'NomadTextField (error)',semanticLabel:'Email',
      touchTargetWidth:double.infinity,touchTargetHeight:56,hasSemanticRole:true),
    const AuditTarget(name:'NomadChip (FilterChip)',semanticLabel:'Non-stop',
      touchTargetWidth:96,touchTargetHeight:AppSpacing.minTouchTarget,hasSemanticRole:true),
    const AuditTarget(name:'NomadChip (ActionChip)',semanticLabel:'Search',
      touchTargetWidth:96,touchTargetHeight:AppSpacing.minTouchTarget,hasSemanticRole:true),
    // Intentional failure for demo
    const AuditTarget(name:'Icon-only button (demo failure)',semanticLabel:'',
      touchTargetWidth:24,touchTargetHeight:24,hasSemanticRole:false),
  ];

  Future<void> _runAudit() async {
    if (_running) return;
    setState(() { _running = true; _hasRun = true; _results = []; });
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final r = <AuditResult>[
      ..._audit.auditTouchTargets(_targets),
      ..._audit.auditSemanticLabels(_targets),
      ..._audit.auditSemanticRoles(_targets),
    ];

    if (mounted) setState(() { _results = r; _running = false; });
  }

  @override
  Widget build(BuildContext context) {
    final passed  = _results.whereType<AuditPass>().length;
    final failed  = _results.whereType<AuditFail>().length;

    return Column(
      children: [
        // Status bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: !_hasRun ? Colors.transparent
              : failed == 0
                ? AppColors.green500.withAlpha(20)
                : AppColors.red500.withAlpha(20),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AuditStat('Passed', passed, AppColors.green500),
              _AuditStat('Failed', failed, AppColors.red500),
              _AuditStat('Pending', _targets.length * 3 - passed - failed, AppColors.grey500),
            ],
          ),
        ),
        // Results list
        Expanded(
          child: _results.isEmpty && !_running
              ? const Center(
                  child: Text('Tap "Run Audit" to check all components',
                    style: TextStyle(color: AppColors.grey500)))
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (_, i) => _AuditResultRow(result: _results[i]),
                ),
        ),
        // Action buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
          child: NomadButton(
            label: _running ? 'Running Audit...' : 'Run Audit',
            loading: _running,
            onPressed: _running ? null : _runAudit,
          ),
        ),
      ],
    );
  }
}

final class _AuditResultRow extends StatelessWidget {
  const _AuditResultRow({required this.result});
  final AuditResult result;

  @override
  Widget build(BuildContext context) {
    final (icon, color, subtitle, hint) = switch (result) {
      AuditPass(checkName: final c, targetName: final n) =>
        (Icons.check_circle, AppColors.green500,
         '$c — ${n}', null),
      AuditFail(checkName: final c, targetName: final n,
                issue: final i, fixHint: final f) =>
        (Icons.cancel, AppColors.red500,
         '$c — $n: $i', f),
    };

    return Semantics(
      label: '${result is AuditPass ? "Pass" : "Fail"}: '
             '${result.checkName} for ${result.targetName}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitle,
                      style: AppTypography.monoSmall.copyWith(
                        color: color, fontWeight: FontWeight.w600),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (hint != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text('Fix: $hint',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.amber700,
                          fontStyle: FontStyle.italic),
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
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

final class _AuditStat extends StatelessWidget {
  const _AuditStat(this.label, this.count, this.color);
  final String label;
  final int    count;
  final Color  color;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$count $label',
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('$count',
        style: AppTypography.headlineMedium.copyWith(
          color: color, fontWeight: FontWeight.w700)),
      Text(label, style: AppTypography.bodySmall.copyWith(color: color)),
    ]),
  );
}

// ══════════════════════════════════════════════════════════════════════
// TAB 3: Gestures — TalkBack gesture simulator
// ══════════════════════════════════════════════════════════════════════

final class _GesturesTab extends StatefulWidget {
  const _GesturesTab();

  @override
  State<_GesturesTab> createState() => _GesturesTabState();
}

final class _GesturesTabState extends State<_GesturesTab> {
  final List<String> _log   = [];
  int   _focusedIndex       = 0;
  bool  _simulatingTalkBack = false;

  static const List<String> _elements = [
    'Book Flight (button)',
    'Save Trip (button)',
    'Departure City (text field)',
    'Non-stop (filter chip)',
    'Search (action chip)',
  ];

  void _swipeRight() {
    setState(() {
      _focusedIndex = (_focusedIndex + 1) % _elements.length;
      _log.add('→ Swipe Right: focused "${_elements[_focusedIndex]}"');
    });
  }

  void _swipeLeft() {
    setState(() {
      _focusedIndex = (_focusedIndex - 1 + _elements.length) % _elements.length;
      _log.add('← Swipe Left: focused "${_elements[_focusedIndex]}"');
    });
  }

  void _doubleTap() {
    _log.add('↩ Double-tap: activated "${_elements[_focusedIndex]}"');
    setState(() {});
  }

  void _singleTap() {
    _log.add('· Single-tap: read "${_elements[_focusedIndex]}" aloud');
    setState(() {});
  }

  void _threeFingerSwipe() {
    _log.add('⟰ 3-finger swipe: scrolled content');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;

    return Column(
      children: [
        // Focused element display
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.semanticOverlay.withAlpha(20),
          child: Column(
            children: [
              Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(Icons.accessibility_new,
                      color: AppColors.semanticOverlay)),
                  const SizedBox(width: AppSpacing.sm),
                  Text('TalkBack Focus',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.semanticOverlay)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Semantics(
                label: 'Focused element ${_elements[_focusedIndex]}. Activate.',
                button: true,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  onTap: _doubleTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.semanticOverlay.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: AppColors.semanticOverlay,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _elements[_focusedIndex],
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.semanticOverlay,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Gesture buttons
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Text('TALKBACK GESTURES',
                style: AppTypography.monoSmall.copyWith(
                  letterSpacing: 2, color: t.onSurfaceColor.withAlpha(140))),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _GestureButton(
                      label: '← Prev',
                      description: 'Swipe Left',
                      icon: Icons.arrow_back,
                      onTap: _swipeLeft,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _GestureButton(
                      label: '→ Next',
                      description: 'Swipe Right',
                      icon: Icons.arrow_forward,
                      onTap: _swipeRight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _GestureButton(
                      label: '· Read',
                      description: 'Single Tap',
                      icon: Icons.touch_app,
                      onTap: _singleTap,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _GestureButton(
                      label: '↩ Activate',
                      description: 'Double Tap',
                      icon: Icons.ads_click,
                      onTap: _doubleTap,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _GestureButton(
                      label: '⟰ Scroll',
                      description: '3-Finger Swipe',
                      icon: Icons.swipe_up,
                      onTap: _threeFingerSwipe,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Log
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.xs),
                  child: Text('GESTURE LOG',
                    style: AppTypography.monoSmall.copyWith(
                      color: const Color(0xFF58A6FF),
                      fontWeight: FontWeight.bold, letterSpacing: 2)),
                ),
                const Divider(height: 1, color: Color(0xFF30363D)),
                Expanded(
                  child: _log.isEmpty
                      ? const Center(
                          child: Text('Use gesture buttons above',
                            style: TextStyle(fontFamily: 'monospace',
                              fontSize: 12, color: Color(0xFF8B949E))))
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          itemCount: _log.length,
                          itemBuilder: (_, i) => Text(_log[i],
                            style: const TextStyle(fontFamily: 'monospace',
                              fontSize: 11, color: Color(0xFFC9D1D9), height: 1.6))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final class _GestureButton extends StatelessWidget {
  const _GestureButton({
    required this.label, required this.description,
    required this.icon, required this.onTap,
  });
  final String label, description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label — $description',
      button: true,
      child: Material(
        color: AppColors.semanticOverlay.withAlpha(20),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSpacing.minTouchTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: AppColors.semanticOverlay, size: 20),
                  const SizedBox(height: AppSpacing.xs),
                  Text(label,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.semanticOverlay,
                      fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                  Text(description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.semanticOverlay.withAlpha(160),
                      fontSize: 9),
                    textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────

final class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text,
        style: AppTypography.monoSmall.copyWith(
          color: AppColors.semanticOverlay,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5)),
    );
  }
}

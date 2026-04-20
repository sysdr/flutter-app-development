import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../main.dart';

final ValueNotifier<DateTime?> _lastMetricsDemoRunAt = ValueNotifier<DateTime?>(null);

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
    _lastMetricsDemoRunAt.value = DateTime.now();
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
            'loading: true with onPressed: null\n'
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
  final _destCtrl    = TextEditingController();
  final _searchCtrl  = TextEditingController();
  final _passCtrl    = TextEditingController();
  bool _obscure      = true;
  bool _showInvalid  = false;

  @override
  void initState() {
    super.initState();
    _cityCtrl.text = 'Mumbai';
    _destCtrl.text = 'Dubai';
    _searchCtrl.text = 'Bali';
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    _destCtrl.dispose();
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
        NomadTextField(
          label: 'Destination City',
          hint: 'e.g. Dubai',
          controller: _destCtrl,
          helperText: _destCtrl.text.trim().isEmpty
              ? 'Enter destination to book flight'
              : 'Flight booked to ${_destCtrl.text.trim()}',
          onChanged: (_) => setState(() {}),
        ),
        ValueListenableBuilder<DateTime?>(
          valueListenable: _lastMetricsDemoRunAt,
          builder: (context, runAt, _) {
            if (runAt == null || _destCtrl.text.trim().isEmpty) {
              return const SizedBox.shrink();
            }
            final bookedAt =
                '${runAt.year}-${runAt.month.toString().padLeft(2, '0')}-${runAt.day.toString().padLeft(2, '0')} '
                '${runAt.hour.toString().padLeft(2, '0')}:${runAt.minute.toString().padLeft(2, '0')}:${runAt.second.toString().padLeft(2, '0')}';
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Flight is booked for ${_destCtrl.text.trim()} at real-time $bookedAt.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.green700),
              ),
            );
          },
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

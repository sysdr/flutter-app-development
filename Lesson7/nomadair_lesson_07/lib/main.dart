import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final launch = (prefs.getInt('launch_count') ?? 0) + 1;
  await prefs.setInt('launch_count', launch);
  final saved = prefs.getInt('theme_mode');
  final mode = saved == null || saved < 0 || saved >= ThemeMode.values.length
      ? ThemeMode.system
      : ThemeMode.values[saved];
  runApp(NomadAirApp(initialMode: mode));
}

class NomadAirApp extends StatefulWidget {
  const NomadAirApp({required this.initialMode, super.key});
  final ThemeMode initialMode;
  @override
  State<NomadAirApp> createState() => _NomadAirAppState();
}

class _NomadAirAppState extends State<NomadAirApp> {
  late ThemeMode mode = widget.initialMode;
  int launchCount = 0;
  ThemeMode savedMode = ThemeMode.system;
  bool tintOn = true;

  final math.Random _rng = math.Random();

  int _demoFlights = 12;
  int _demoLatencyMs = 64;
  int _demoSuccessPct = 88;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      launchCount = prefs.getInt('launch_count') ?? 0;
      final idx = prefs.getInt('theme_mode');
      savedMode = idx == null || idx < 0 || idx >= ThemeMode.values.length
          ? ThemeMode.system
          : ThemeMode.values[idx];
    });
  }

  void _runMetricsDemo() {
    setState(() {
      _demoFlights = 20 + _rng.nextInt(80);
      _demoLatencyMs = 40 + _rng.nextInt(180);
      _demoSuccessPct = 75 + _rng.nextInt(24);
    });
  }

  Future<void> _save(ThemeMode m) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', m.index);
    if (!mounted) return;
    setState(() => mode = m);
    await _reload();
  }

  Future<void> _clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('theme_mode');
    if (!mounted) return;
    setState(() => mode = ThemeMode.system);
    await _reload();
  }

  String modeText(ThemeMode m) => m == ThemeMode.dark
      ? 'Dark'
      : m == ThemeMode.light
          ? 'Light'
          : 'System';

  @override
  Widget build(BuildContext context) {
    final isDark = mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DarkModeExplorer',
      themeMode: mode,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF1A73E8)),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF6EA8FF),
      ),
      home: DarkModeExplorer(
        isDark: isDark,
        tintOn: tintOn,
        onTintChanged: (v) => setState(() => tintOn = v),
        onSave: _save,
        onClear: _clear,
        launchCount: launchCount,
        savedMode: savedMode,
        modeText: modeText,
        onRunMetricsDemo: _runMetricsDemo,
        demoFlights: _demoFlights,
        demoLatencyMs: _demoLatencyMs,
        demoSuccessPct: _demoSuccessPct,
      ),
    );
  }
}

class DarkModeExplorer extends StatefulWidget {
  const DarkModeExplorer({
    required this.isDark,
    required this.tintOn,
    required this.onTintChanged,
    required this.onSave,
    required this.onClear,
    required this.launchCount,
    required this.savedMode,
    required this.modeText,
    required this.onRunMetricsDemo,
    required this.demoFlights,
    required this.demoLatencyMs,
    required this.demoSuccessPct,
    super.key,
  });

  final bool isDark;
  final bool tintOn;
  final ValueChanged<bool> onTintChanged;
  final Future<void> Function(ThemeMode) onSave;
  final Future<void> Function() onClear;
  final int launchCount;
  final ThemeMode savedMode;
  final String Function(ThemeMode) modeText;
  final VoidCallback onRunMetricsDemo;
  final int demoFlights;
  final int demoLatencyMs;
  final int demoSuccessPct;

  @override
  State<DarkModeExplorer> createState() => _DarkModeExplorerState();
}

class _DarkModeExplorerState extends State<DarkModeExplorer>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('DarkModeExplorer'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'TOKENS'),
            Tab(text: 'TINTING'),
            Tab(text: 'PERSIST'),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _tokensTab(context, bottom),
            _tintingTab(context, bottom),
            _persistTab(context, bottom),
          ],
        ),
      ),
    );
  }

  Widget _metricChip(String label, String value, {Key? key}) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                key: key,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _liveMetricsBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Live metrics (demo)', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            _metricChip(
              'Flights',
              '${widget.demoFlights}',
              key: const ValueKey<String>('metric_flights_value'),
            ),
            const SizedBox(width: 8),
            _metricChip(
              'Latency (ms)',
              '${widget.demoLatencyMs}',
            ),
            const SizedBox(width: 8),
            _metricChip(
              'Success (%)',
              '${widget.demoSuccessPct}',
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: widget.onRunMetricsDemo,
          child: const Text('Run metrics demo'),
        ),
      ],
    );
  }

  Widget _tokensTab(BuildContext context, double bottomInset) {
    return ListView(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
      children: [
        const Text('LIGHT THEME | DARK THEME'),
        const SizedBox(height: 8),
        const Card(
          child: ListTile(
            title: Text('primaryColor -> primaryColor'),
            subtitle: Text('#1A73E8 (4.98:1) -> #8AB4F8 (4.73:1)'),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text('onSurfaceColor -> onSurfaceColor'),
            subtitle: Text('#1A1A1A (16.12:1) -> #E6E6E6 (15.20:1)'),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text('dividerColor -> dividerColor'),
            subtitle: Text('#E0E0E0 (2.68:1) -> #2A2031 (4.35:1)'),
          ),
        ),
        const SizedBox(height: 16),
        _liveMetricsBlock(),
      ],
    );
  }

  Widget _tintingTab(BuildContext context, double bottomInset) {
    return ListView(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
      children: [
        SwitchListTile(
          title: const Text('Dark Tint'),
          subtitle: const Text('Apply image overlay tint in dark mode'),
          value: widget.tintOn,
          onChanged: widget.onTintChanged,
        ),
        const SizedBox(height: 4),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Light Mode'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ColorFiltered(
                    colorFilter: widget.isDark && widget.tintOn
                        ? const ColorFilter.mode(
                            Color(0x66303050),
                            BlendMode.srcATop,
                          )
                        : const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.srcATop,
                          ),
                    child: Container(
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.isDark && widget.tintOn
                            ? 'Dark Tint ON'
                            : 'Dark Tint OFF',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _persistTab(BuildContext context, double bottomInset) {
    return ListView(
      padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
      children: [
        _liveMetricsBlock(),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            title: const Text('Launch Count'),
            subtitle: const Text('Increments on each full app start'),
            trailing: Text(
              '${widget.launchCount}',
              key: const ValueKey<String>('launch_count_value'),
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Saved Mode'),
            trailing: Text(
              widget.modeText(widget.savedMode),
              key: const ValueKey<String>('saved_mode_value'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 400) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => widget.onSave(ThemeMode.light),
                    child: const Text('Save Light'),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => widget.onSave(ThemeMode.dark),
                    child: const Text('Save Dark'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => widget.onClear(),
                    child: const Text('Clear'),
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.onSave(ThemeMode.light),
                    child: const Text('Save Light'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onSave(ThemeMode.dark),
                    child: const Text('Save Dark'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.onClear(),
                    child: const Text('Clear'),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Tip: Use tab bar to switch; scroll vertically inside each tab. '
          'For persistence, use Save, then fully restart the app to verify launch count and theme.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const NomadAirApp());

final class NomadAirApp extends StatefulWidget {
  const NomadAirApp({super.key});

  @override
  State<NomadAirApp> createState() => _NomadAirAppState();
}

final class _NomadAirAppState extends State<NomadAirApp> {
  ThemeMode _mode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'NomadAir Lesson 04',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: _mode,
        home: MetricsDemoScreen(
          isDark: _mode == ThemeMode.dark,
          onToggleTheme: toggleTheme,
        ),
      );
}

ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue600,
      brightness: brightness,
    ),
    extensions: <ThemeExtension<dynamic>>[
      brightness == Brightness.dark
          ? NomadThemeExtension.dark
          : NomadThemeExtension.light,
    ],
  );
}

abstract final class AppColors {
  static const Color blue300 = Color(0xFF8AB4F8);
  static const Color blue600 = Color(0xFF1A73E8);
  static const Color green300 = Color(0xFF81C995);
  static const Color green500 = Color(0xFF34A853);
  static const Color amber300 = Color(0xFFFDD663);
  static const Color amber600 = Color(0xFFE8A020);
  static const Color red500 = Color(0xFFEA4335);
  static const Color grey200 = Color(0xFFE8EAED);
  static const Color grey500 = Color(0xFF9AA0A6);
  static const Color grey900 = Color(0xFF202124);
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkBackground = Color(0xFF121212);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
}

abstract final class AppTypography {
  static const TextStyle headline = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
  );
}

final class NomadThemeExtension extends ThemeExtension<NomadThemeExtension> {
  const NomadThemeExtension({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandAccent,
    required this.surfaceColor,
    required this.onSurfaceColor,
  });

  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandAccent;
  final Color surfaceColor;
  final Color onSurfaceColor;

  static const NomadThemeExtension light = NomadThemeExtension(
    brandPrimary: AppColors.blue600,
    brandSecondary: AppColors.green500,
    brandAccent: AppColors.amber600,
    surfaceColor: AppColors.white,
    onSurfaceColor: AppColors.grey900,
  );

  static const NomadThemeExtension dark = NomadThemeExtension(
    brandPrimary: AppColors.blue300,
    brandSecondary: AppColors.green300,
    brandAccent: AppColors.amber300,
    surfaceColor: AppColors.darkSurface,
    onSurfaceColor: AppColors.grey200,
  );

  @override
  NomadThemeExtension copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandAccent,
    Color? surfaceColor,
    Color? onSurfaceColor,
  }) {
    return NomadThemeExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandAccent: brandAccent ?? this.brandAccent,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
    );
  }

  @override
  NomadThemeExtension lerp(NomadThemeExtension? other, double t) {
    if (other == null) {
      return this;
    }
    return NomadThemeExtension(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      onSurfaceColor: Color.lerp(onSurfaceColor, other.onSurfaceColor, t)!,
    );
  }
}

enum WcagLevel { aaa, aa, aaLarge, fail }

extension on WcagLevel {
  String get label => switch (this) {
        WcagLevel.aaa => 'AAA',
        WcagLevel.aa => 'AA',
        WcagLevel.aaLarge => 'AA Large',
        WcagLevel.fail => 'Fail',
      };
}

abstract final class ContrastCalculator {
  static (double ratio, WcagLevel level) ratio(Color foreground, Color background) {
    final fg = foreground.computeLuminance();
    final bg = background.computeLuminance();
    final lighter = fg > bg ? fg : bg;
    final darker = fg > bg ? bg : fg;
    final value = (lighter + 0.05) / (darker + 0.05);
    final level = switch (value) {
      >= 7.0 => WcagLevel.aaa,
      >= 4.5 => WcagLevel.aa,
      >= 3.0 => WcagLevel.aaLarge,
      _ => WcagLevel.fail,
    };
    return (value, level);
  }
}

final class MetricsDemoScreen extends StatefulWidget {
  const MetricsDemoScreen({
    required this.isDark,
    required this.onToggleTheme,
    super.key,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<MetricsDemoScreen> createState() => _MetricsDemoScreenState();
}

final class _MetricsDemoScreenState extends State<MetricsDemoScreen>
    with SingleTickerProviderStateMixin {
  late final Timer _timer;
  late final TabController _tabController;

  int _flightsChecked = 3;
  int _latencyMs = 124;
  int _successRate = 97;
  int _tick = 0;
  bool _typoDarkPreview = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _tick += 1;
        _flightsChecked += 2;
        _latencyMs = 100 + (_tick * 7) % 55;
        _successRate = 94 + (_tick % 6);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  List<({String name, Color color})> get _colorTokens => <({String name, Color color})>[
        (name: 'blue600', color: AppColors.blue600),
        (name: 'blue300', color: AppColors.blue300),
        (name: 'green500', color: AppColors.green500),
        (name: 'green300', color: AppColors.green300),
        (name: 'amber600', color: AppColors.amber600),
        (name: 'amber300', color: AppColors.amber300),
        (name: 'red500', color: AppColors.red500),
        (name: 'grey900', color: AppColors.grey900),
        (name: 'grey200', color: AppColors.grey200),
        (name: 'darkSurface', color: AppColors.darkSurface),
      ];

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('NomadAir Metrics Demo'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: const Text('Flights Checked'),
                    trailing: Text('$_flightsChecked'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Latency (ms)'),
                    trailing: Text('$_latencyMs'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Success Rate (%)'),
                    trailing: Text('$_successRate'),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _runDemo,
                  child: const Text('Run Demo'),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'Colors'),
              Tab(text: 'Typography'),
              Tab(text: 'Theme'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _colorTokens.length,
                  itemBuilder: (BuildContext context, int index) {
                    final token = _colorTokens[index];
                    final (ratioWhite, levelWhite) = ContrastCalculator.ratio(
                      token.color,
                      AppColors.white,
                    );
                    final (ratioBlack, levelBlack) = ContrastCalculator.ratio(
                      token.color,
                      AppColors.black,
                    );
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: token.color,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                        title: Text('AppColors.${token.name}', style: AppTypography.mono),
                        subtitle: Text(
                          'on White ${ratioWhite.toStringAsFixed(1)}:1 (${levelWhite.label})  '
                          '|  on Black ${ratioBlack.toStringAsFixed(1)}:1 (${levelBlack.label})',
                        ),
                      ),
                    );
                  },
                ),
                Column(
                  children: <Widget>[
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _typoDarkPreview = !_typoDarkPreview;
                        });
                      },
                      child: Text(
                        _typoDarkPreview ? 'Switch to Light BG' : 'Switch to Dark BG',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        color: _typoDarkPreview ? AppColors.darkBackground : AppColors.white,
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: <Widget>[
                            Text(
                              'Display / Headline',
                              style: AppTypography.headline.copyWith(
                                color: _typoDarkPreview ? AppColors.grey200 : AppColors.grey900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'NomadAir Typography Preview',
                              style: AppTypography.body.copyWith(
                                fontSize: 16,
                                color: _typoDarkPreview ? AppColors.grey200 : AppColors.grey900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'body / mono',
                              style: AppTypography.mono.copyWith(
                                color: _typoDarkPreview ? AppColors.grey500 : AppColors.grey900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    FilledButton(
                      onPressed: widget.onToggleTheme,
                      child: Text(widget.isDark ? 'Switch to Light' : 'Switch to Dark'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.isDark ? 'Dark Theme Active' : 'Light Theme Active',
                      style: AppTypography.headline.copyWith(color: ext.brandPrimary),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: ext.surfaceColor,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Semantic Tokens (ThemeExtension)',
                              style: AppTypography.mono.copyWith(color: ext.onSurfaceColor),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'brandPrimary: ${ext.brandPrimary.toARGB32().toRadixString(16)}',
                              style: TextStyle(color: ext.onSurfaceColor),
                            ),
                            Text(
                              'brandSecondary: ${ext.brandSecondary.toARGB32().toRadixString(16)}',
                              style: TextStyle(color: ext.onSurfaceColor),
                            ),
                            Text(
                              'brandAccent: ${ext.brandAccent.toARGB32().toRadixString(16)}',
                              style: TextStyle(color: ext.onSurfaceColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

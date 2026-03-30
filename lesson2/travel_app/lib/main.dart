import 'package:flutter/material.dart';
import 'package:travel_app/design_system/theme/app_theme.dart';
import 'package:travel_app/design_system/tokens/color_tokens.dart';
import 'package:travel_app/design_system/tokens/typography_tokens.dart';
import 'package:travel_app/design_system/components/app_button.dart';
import 'package:travel_app/design_system/components/app_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _primaryTaps = 0;
  int _accentTaps = 0;
  int _fieldEdits = 0;
  int _demoRuns = 0;
  late final TextEditingController _destinationController;

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _runDemo() {
    setState(() {
      _demoRuns += 1;
      _primaryTaps += 1;
      _accentTaps += 1;
      _fieldEdits += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    final AppTypography appTypography = Theme.of(context).extension<AppTypography>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Day 2: Design System + Metrics',
          style: appTypography.headline1?.copyWith(
            fontSize: 20,
            color: appColors.onPrimary,
          ),
        ),
        backgroundColor: appColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dashboard',
                      style: appTypography.headline1?.copyWith(color: appColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Metrics update when you use the demo below or tap "Run demo".',
                      style: appTypography.bodyText1?.copyWith(color: appColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    _metricRow(context, 'Primary button taps', _primaryTaps, const ValueKey<String>('metric_primary')),
                    _metricRow(context, 'Accent button taps', _accentTaps, const ValueKey<String>('metric_accent')),
                    _metricRow(context, 'Destination edits', _fieldEdits, const ValueKey<String>('metric_field')),
                    _metricRow(context, 'Demo runs', _demoRuns, const ValueKey<String>('metric_demo')),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Run demo (updates all metrics)',
                      onPressed: _runDemo,
                      isPrimary: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Design system demo',
              style: appTypography.headline1?.copyWith(color: appColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tokens: AppTypography + AppColors',
              style: appTypography.bodyText1?.copyWith(color: appColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Destination',
              hintText: 'e.g., Paris, France',
              controller: _destinationController,
              onChanged: (_) {
                setState(() {
                  _fieldEdits += 1;
                });
              },
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'Book a Flight (Primary)',
              onPressed: () {
                setState(() => _primaryTaps += 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Primary Button Tapped!',
                      style: appTypography.bodyText1,
                    ),
                  ),
                );
              },
              isPrimary: true,
            ),
            const SizedBox(height: 10),
            AppButton(
              text: 'Explore More (Accent)',
              onPressed: () {
                setState(() => _accentTaps += 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Accent Button Tapped!',
                      style: appTypography.bodyText1,
                    ),
                  ),
                );
              },
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricRow(BuildContext context, String label, int value, Key valueKey) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final appTypography = Theme.of(context).extension<AppTypography>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: appTypography.bodyText1?.copyWith(color: appColors.textPrimary),
            ),
          ),
          Text(
            '$value',
            key: valueKey,
            style: appTypography.headline1?.copyWith(
              fontSize: 18,
              color: appColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

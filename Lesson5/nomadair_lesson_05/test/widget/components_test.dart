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

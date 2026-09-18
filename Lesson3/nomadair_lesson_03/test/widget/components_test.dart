import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_ui/ui.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: NomadAirTheme.light(),
      home: Scaffold(body: child),
    );

void main() {
  group('NomadButton (nomadair_ui)', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadButton(label: 'Book Flight', onPressed: () {})),
      );
      expect(find.text('Book Flight'), findsOneWidget);
    });

    testWidgets('shows progress indicator when loading', (tester) async {
      await tester.pumpWidget(
        _wrap(
          NomadButton(
            label: 'Searching',
            onPressed: () {},
            loading: true,
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Searching'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const NomadButton(label: 'Disabled', onPressed: null)),
      );
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('has Semantics button=true', (tester) async {
      await tester.pumpWidget(
        _wrap(NomadButton(label: 'Book', onPressed: () {})),
      );
      final sem = tester.getSemantics(find.byType(NomadButton));
      expect(sem.hasFlag(SemanticsFlag.isButton), isTrue);
    });
  });

  group('NomadCard (nomadair_ui)', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NomadCard(child: Text('Flight Card')),
        ),
      );
      expect(find.text('Flight Card'), findsOneWidget);
    });

    testWidgets('invokes onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          NomadCard(
            onTap: () => tapped = true,
            child: const Text('Tap Me'),
          ),
        ),
      );
      await tester.tap(find.text('Tap Me'));
      expect(tapped, isTrue);
    });
  });

  group('NomadAirTheme (nomadair_ui)', () {
    testWidgets('light theme has useMaterial3 true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: NomadAirTheme.light(), home: const Placeholder()),
      );
      final ctx = tester.element(find.byType(Placeholder));
      expect(Theme.of(ctx).useMaterial3, isTrue);
    });

    testWidgets('dark theme has useMaterial3 true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: NomadAirTheme.dark(),
          home: const Placeholder(),
        ),
      );
      final ctx = tester.element(find.byType(Placeholder));
      expect(Theme.of(ctx).useMaterial3, isTrue);
    });
  });
}

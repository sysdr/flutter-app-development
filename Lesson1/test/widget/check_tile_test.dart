import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_01/core/theme/nomadair_theme.dart';
import 'package:nomadair_lesson_01/features/env_check/models/env_check_result.dart';
import 'package:nomadair_lesson_01/features/env_check/widgets/check_tile.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: NomadAirTheme.light(),
      home: Scaffold(body: child),
    );

void main() {
  group('CheckTile widget', () {
    testWidgets('shows check_circle icon when passing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CheckTile(
            result: CheckPassing(
              name: 'Platform',
              description: 'Platform check',
              value: 'ANDROID',
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Platform'), findsOneWidget);
      expect(find.text('ANDROID'), findsOneWidget);
    });

    testWidgets('shows cancel icon and fix text when failing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CheckTile(
            result: CheckFailing(
              name: 'Screen',
              description: 'Screen size',
              error: 'Below minimum',
              fix: 'Use Pixel 7 AVD',
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.text('Below minimum'), findsOneWidget);
      expect(find.textContaining('Pixel 7 AVD'), findsOneWidget);
    });

    testWidgets('shows Waiting... text when pending', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CheckTile(
            result: CheckPending(
              name: 'Pending',
              description: 'Not yet run',
            ),
          ),
        ),
      );
      expect(find.text('Waiting...'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    });

    testWidgets('has semantic label combining name and status', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CheckTile(
            result: CheckPassing(
              name: 'Platform',
              description: 'Platform check',
              value: 'ANDROID',
            ),
          ),
        ),
      );
      final semantics = tester.getSemantics(find.byType(CheckTile));
      expect(semantics.label, contains('Platform'));
      expect(semantics.label, contains('passed'));
    });

    testWidgets('fix text is absent when check is passing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CheckTile(
            result: CheckPassing(
              name: 'Dart',
              description: 'Dart version',
              value: 'Dart 3.3.0',
            ),
          ),
        ),
      );
      expect(find.textContaining('Fix:'), findsNothing);
    });
  });
}

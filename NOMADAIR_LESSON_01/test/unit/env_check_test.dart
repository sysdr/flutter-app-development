import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_01/features/env_check/models/env_check_result.dart';

void main() {
  group('EnvCheckResult sealed class', () {
    test('CheckPassing carries a non-empty value string', () {
      const result = CheckPassing(
        name: 'Platform',
        description: 'Platform check',
        value: 'ANDROID',
      );
      expect(result.value, isNotEmpty);
      expect(result, isA<EnvCheckResult>());
    });

    test('CheckFailing exposes both error and fix', () {
      const result = CheckFailing(
        name: 'Screen',
        description: 'Screen size',
        error: '320x480 — below minimum',
        fix: 'Use Pixel 7 AVD',
      );
      expect(result.error, contains('below minimum'));
      expect(result.fix, isNotEmpty);
    });

    test('Dart 3 exhaustive switch covers all four states', () {
      const EnvCheckResult result = CheckPending(
        name: 'Test',
        description: 'Test description',
      );

      final label = switch (result) {
        CheckPending()  => 'pending',
        CheckRunning()  => 'running',
        CheckPassing()  => 'passed',
        CheckFailing()  => 'failed',
      };

      expect(label, equals('pending'));
    });

    test('CheckRunning is distinct from all terminal states', () {
      const running = CheckRunning(name: 'X', description: 'X');
      expect(running, isNot(isA<CheckPassing>()));
      expect(running, isNot(isA<CheckFailing>()));
      expect(running, isNot(isA<CheckPending>()));
    });

    test('Record destructuring extracts correct fields', () {
      const result = CheckPassing(
        name: 'Dart',
        description: 'Dart version',
        value: 'Dart 3.3.0',
      );

      final (_, __, value) = switch (result) {
        CheckPending()               => ('grey',    'grey',    'Waiting...'),
        CheckRunning()               => ('blue',    'blue',    'Running...'),
        CheckPassing(value: final v) => ('green',   'green',   v),
        CheckFailing(error: final e) => ('red',     'red',     e),
      };

      expect(value, equals('Dart 3.3.0'));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_lesson_08/core/services/accessibility_audit.dart';

void main() {
  const audit = DefaultAccessibilityAudit();

  group('AuditResult sealed class', () {
    test('exhaustive switch compiles and resolves correctly', () {
      const AuditResult r = AuditPass(
        checkName: 'Touch Target', targetName: 'NomadButton');
      final label = switch (r) {
        AuditPass() => 'pass',
        AuditFail() => 'fail',
      };
      expect(label, equals('pass'));
    });

    test('AuditFail carries issue and fixHint', () {
      const r = AuditFail(
        checkName: 'Touch Target', targetName: 'Icon',
        issue: '24×24 dp below 48dp', fixHint: 'Use IconButton');
      expect(r.issue, contains('24×24'));
      expect(r.fixHint, contains('IconButton'));
    });
  });

  group('DefaultAccessibilityAudit.auditTouchTargets', () {
    test('48×48 target passes', () {
      final results = audit.auditTouchTargets([
        const AuditTarget(name: 'Btn', semanticLabel: 'Book',
          touchTargetWidth: 48, touchTargetHeight: 48, hasSemanticRole: true),
      ]);
      expect(results.single, isA<AuditPass>());
    });

    test('24×24 target fails with helpful fixHint', () {
      final results = audit.auditTouchTargets([
        const AuditTarget(name: 'Icon', semanticLabel: 'Icon',
          touchTargetWidth: 24, touchTargetHeight: 24, hasSemanticRole: false),
      ]);
      final fail = results.single as AuditFail;
      expect(fail.issue, contains('below minimum'));
      expect(fail.fixHint, contains('ConstrainedBox'));
    });

    test('200×48 wide-but-not-short passes (landscape button)', () {
      final r = audit.auditTouchTargets([
        const AuditTarget(name: 'Wide', semanticLabel: 'Wide',
          touchTargetWidth: 200, touchTargetHeight: 48, hasSemanticRole: true),
      ]);
      expect(r.single, isA<AuditPass>());
    });

    test('48×30 fails — height below minimum', () {
      final r = audit.auditTouchTargets([
        const AuditTarget(name: 'Short', semanticLabel: 'Short',
          touchTargetWidth: 48, touchTargetHeight: 30, hasSemanticRole: true),
      ]);
      expect(r.single, isA<AuditFail>());
    });

    test('all 9 passing targets produce 9 AuditPass results', () {
      final targets = List.generate(9, (i) => AuditTarget(
        name: 'Component $i', semanticLabel: 'Label $i',
        touchTargetWidth: 48, touchTargetHeight: 48, hasSemanticRole: true));
      final results = audit.auditTouchTargets(targets);
      expect(results.every((r) => r is AuditPass), isTrue);
    });
  });

  group('DefaultAccessibilityAudit.auditSemanticLabels', () {
    test('non-empty label passes', () {
      final r = audit.auditSemanticLabels([
        const AuditTarget(name: 'Btn', semanticLabel: 'Book Flight',
          touchTargetWidth: 48, touchTargetHeight: 48, hasSemanticRole: true),
      ]);
      expect(r.single, isA<AuditPass>());
    });

    test('empty label fails with fixHint', () {
      final r = audit.auditSemanticLabels([
        const AuditTarget(name: 'Icon', semanticLabel: '',
          touchTargetWidth: 48, touchTargetHeight: 48, hasSemanticRole: false),
      ]);
      final fail = r.single as AuditFail;
      expect(fail.issue, contains('empty'));
      expect(fail.fixHint, contains('Semantics'));
    });

    test('whitespace-only label fails', () {
      final r = audit.auditSemanticLabels([
        const AuditTarget(name: 'X', semanticLabel: '   ',
          touchTargetWidth: 48, touchTargetHeight: 48, hasSemanticRole: true),
      ]);
      expect(r.single, isA<AuditFail>());
    });
  });

  group('DefaultAccessibilityAudit.auditSemanticRoles', () {
    test('hasSemanticRole=true passes', () {
      final r = audit.auditSemanticRoles([
        const AuditTarget(name: 'Btn', semanticLabel: 'Book',
          touchTargetWidth: 48, touchTargetHeight: 48, hasSemanticRole: true),
      ]);
      expect(r.single, isA<AuditPass>());
    });

    test('hasSemanticRole=false fails with fixHint', () {
      final r = audit.auditSemanticRoles([
        const AuditTarget(name: 'Icon', semanticLabel: 'Icon',
          touchTargetWidth: 24, touchTargetHeight: 24, hasSemanticRole: false),
      ]);
      final fail = r.single as AuditFail;
      expect(fail.fixHint, contains('button: true'));
    });
  });

  group('FlightModel.accessibilityLabel', () {
    const f = FlightModel(
      id: 'AI-101', airline: 'Air India',
      origin: 'BOM', destination: 'DEL',
      durationMinutes: 125, priceInr: 4200, stops: 0,
    );

    test('contains airline name', () =>
      expect(f.accessibilityLabel, contains('Air India')));
    test('contains route', () =>
      expect(f.accessibilityLabel, contains('BOM → DEL')));
    test('contains price', () =>
      expect(f.accessibilityLabel, contains('₹4200')));
    test('contains stops label', () =>
      expect(f.accessibilityLabel, contains('Non-stop')));
    test('contains duration', () =>
      expect(f.accessibilityLabel, contains('2h 5m')));
  });
}

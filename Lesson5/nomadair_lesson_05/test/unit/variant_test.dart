import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_ui/ui.dart';

void main() {
  group('ButtonVariant sealed class', () {
    test('three concrete subtypes exist', () {
      const variants = <ButtonVariant>[
        FilledVariant(),
        OutlinedVariant(),
        GhostVariant(),
      ];
      expect(variants.length, equals(3));
    });

    test('exhaustive switch covers all variants', () {
      const ButtonVariant v = FilledVariant();
      final label = switch (v) {
        FilledVariant()   => 'filled',
        OutlinedVariant() => 'outlined',
        GhostVariant()    => 'ghost',
      };
      expect(label, equals('filled'));
    });

    test('each variant is distinct type', () {
      const f = FilledVariant();
      const o = OutlinedVariant();
      const g = GhostVariant();
      expect(f, isNot(isA<OutlinedVariant>()));
      expect(o, isNot(isA<GhostVariant>()));
      expect(g, isNot(isA<FilledVariant>()));
    });
  });

  group('CardVariant sealed class', () {
    test('exhaustive switch covers all variants', () {
      const CardVariant v = ElevatedCard();
      final elev = switch (v) {
        FlatCard()     => 0.0,
        ElevatedCard() => 2.0,
        OutlinedCard() => 0.0,
      };
      expect(elev, equals(2.0));
    });
  });

  group('ChipVariant sealed class', () {
    test('FilterChipVariant and ActionChipVariant are distinct', () {
      const f = FilterChipVariant();
      const a = ActionChipVariant();
      expect(f, isNot(isA<ActionChipVariant>()));
      expect(a, isNot(isA<FilterChipVariant>()));
    });

    test('selected is meaningful only for FilterChipVariant', () {
      const ChipVariant v = FilterChipVariant();
      // Simulate the pattern used in NomadChip.build
      final hasSelected = switch (v) {
        FilterChipVariant() => true,
        ActionChipVariant() => false,
      };
      expect(hasSelected, isTrue);
    });
  });
}

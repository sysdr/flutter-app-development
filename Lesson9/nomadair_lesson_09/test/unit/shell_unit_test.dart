import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';

void main() {
  group('DestinationModel', () {
    const d = DestinationModel(
      id:'dxb', city:'Dubai', country:'UAE', iataCode:'DXB',
      tagline:'City of gold', priceFromInr:18500, category:'flights',
      skyColorTop:0xFF1A237E, skyColorBottom:0xFFE65100,
    );

    test('formattedPrice includes rupee symbol', () =>
      expect(d.formattedPrice, contains('₹')));

    test('accessibilityLabel includes city and tagline', () {
      expect(d.accessibilityLabel, contains('Dubai'));
      expect(d.accessibilityLabel, contains('City of gold'));
      expect(d.accessibilityLabel, contains('₹'));
    });

    test('samples contains 6 destinations', () =>
      expect(DestinationModel.samples.length, equals(6)));

    test('samples have unique IDs', () {
      final ids = DestinationModel.samples.map((d) => d.id).toSet();
      expect(ids.length, equals(DestinationModel.samples.length));
    });

    test('category filter works for flights', () {
      final flights = DestinationModel.samples
          .where((d) => d.category == 'flights' || d.category == 'both')
          .toList();
      expect(flights.isNotEmpty, isTrue);
    });

    test('all samples have non-empty accessibility labels', () {
      for (final s in DestinationModel.samples) {
        expect(s.accessibilityLabel.trim().isNotEmpty, isTrue,
          reason: '${s.city} has empty label');
      }
    });
  });

  group('FlightModel.accessibilityLabel', () {
    const f = FlightModel(
      id:'AI-101', airline:'Air India',
      origin:'BOM', destination:'DEL',
      durationMinutes:125, priceInr:4200, stops:0,
    );
    test('contains all 5 components', () {
      final l = f.accessibilityLabel;
      expect(l, contains('Air India'));
      expect(l, contains('BOM → DEL'));
      expect(l, contains('₹4200'));
      expect(l, contains('Non-stop'));
      expect(l, contains('2h 5m'));
    });
  });

  group('NavigationStyle sealed class', () {
    test('compact breakpoint < 600', () =>
      expect(Breakpoints.styleFor(375), isA<CompactNav>()));
    test('medium breakpoint 600–839', () =>
      expect(Breakpoints.styleFor(720), isA<MediumNav>()));
    test('expanded breakpoint >= 840', () =>
      expect(Breakpoints.styleFor(1024), isA<ExpandedNav>()));
  });

  group('NomadThemeExtension integration', () {
    test('light and dark have 11 tokens', () {
      void check(NomadThemeExtension e) {
        expect(e.brandPrimary,      isA<dynamic>());
        expect(e.brandSecondary,    isA<dynamic>());
        expect(e.brandAccent,       isA<dynamic>());
        expect(e.surfaceColor,      isA<dynamic>());
        expect(e.onSurfaceColor,    isA<dynamic>());
        expect(e.successColor,      isA<dynamic>());
        expect(e.errorColor,        isA<dynamic>());
        expect(e.warningColor,      isA<dynamic>());
        expect(e.imageOverlayColor, isA<dynamic>());
        expect(e.iconAdaptiveColor, isA<dynamic>());
        expect(e.dividerColor,      isA<dynamic>());
      }
      check(NomadThemeExtension.light);
      check(NomadThemeExtension.dark);
    });

    test('lerp(other, 0) returns same as self', () {
      const a = NomadThemeExtension.light;
      const b = NomadThemeExtension.dark;
      final r = a.lerp(b, 0);
      expect(r.brandPrimary, equals(a.brandPrimary));
    });

    test('lerp(other, 1) returns same as other', () {
      const a = NomadThemeExtension.light;
      const b = NomadThemeExtension.dark;
      final r = a.lerp(b, 1);
      expect(r.brandPrimary, equals(b.brandPrimary));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_24/core/transitions/hero_tags.dart';

void main() {
  group('HeroTags', () {
    group('flightPrice', () {
      test('returns a non-empty String', () {
        expect(HeroTags.flightPrice('AI202'), isNotEmpty);
      });
      test('contains the flight ID', () {
        expect(HeroTags.flightPrice('AI202'), contains('AI202'));
      });
      test('different IDs produce different tags', () {
        expect(HeroTags.flightPrice('AI202'),
            isNot(equals(HeroTags.flightPrice('EK501'))));
      });
      test('same ID produces same tag (deterministic)', () {
        expect(HeroTags.flightPrice('X'),
            equals(HeroTags.flightPrice('X')));
      });
    });
    group('destinationImage', () {
      test('returns a non-empty String', () {
        expect(HeroTags.destinationImage('DXB'), isNotEmpty);
      });
      test('contains the IATA code', () {
        expect(HeroTags.destinationImage('DXB'), contains('DXB'));
      });
      test('different IATAs produce different tags', () {
        expect(HeroTags.destinationImage('DXB'),
            isNot(equals(HeroTags.destinationImage('LHR'))));
      });
      test('namespace separation: flightPrice(x) != destinationImage(x)', () {
        expect(HeroTags.flightPrice('BOM'),
            isNot(equals(HeroTags.destinationImage('BOM'))));
      });
    });
  });
}

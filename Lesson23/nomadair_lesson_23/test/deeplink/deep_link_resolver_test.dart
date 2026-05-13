import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_23/core/deeplink/deep_link_intent.dart';
import 'package:nomadair_lesson_23/core/deeplink/deep_link_resolver.dart';

const _r = DeepLinkResolver();

Uri _uri(String path) => Uri.parse('nomadair://search$path');

void main() {
  group('DeepLinkResolver', () {

    group('missing / malformed params', () {
      test('no from= → InvalidIntent', () {
        final i = _r.resolve(_uri(''));
        expect(i, isA<InvalidIntent>());
      });

      test('empty from= → InvalidIntent', () {
        final i = _r.resolve(_uri('?from='));
        expect(i, isA<InvalidIntent>());
      });

      test('unknown from IATA → InvalidIntent', () {
        final i = _r.resolve(_uri('?from=ZZZ'));
        expect(i, isA<InvalidIntent>());
        expect((i as InvalidIntent).reason, contains('ZZZ'));
      });

      test('unknown to IATA → InvalidIntent', () {
        final i = _r.resolve(_uri('?from=BOM&to=ZZZ'));
        expect(i, isA<InvalidIntent>());
        expect((i as InvalidIntent).reason, contains('ZZZ'));
      });

      test('same origin and dest → InvalidIntent', () {
        final i = _r.resolve(_uri('?from=BOM&to=BOM'));
        expect(i, isA<InvalidIntent>());
      });

      test('invalid date format → InvalidIntent', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB&date=15-08-2025'));
        expect(i, isA<InvalidIntent>());
      });

      test('non-numeric date → InvalidIntent', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB&date=next-monday'));
        expect(i, isA<InvalidIntent>());
      });
    });

    group('PreFillIntent', () {
      test('from= only → PreFillIntent with origin', () {
        final i = _r.resolve(_uri('?from=BOM'));
        expect(i, isA<PreFillIntent>());
        expect((i as PreFillIntent).originIata, 'BOM');
        expect(i.destinationIata, isNull);
      });

      test('from= + to= (no date) → PreFillIntent with both IATAs', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB'));
        expect(i, isA<PreFillIntent>());
        final p = i as PreFillIntent;
        expect(p.originIata, 'BOM');
        expect(p.destinationIata, 'DXB');
        expect(p.date, isNull);
      });

      test('from= + date (no to=) → PreFillIntent with origin + date', () {
        final i = _r.resolve(_uri('?from=BOM&date=2025-08-15'));
        expect(i, isA<PreFillIntent>());
        final p = i as PreFillIntent;
        expect(p.originIata, 'BOM');
        expect(p.date, DateTime(2025, 8, 15));
      });

      test('IATA lookup is case-insensitive', () {
        final i = _r.resolve(_uri('?from=bom&to=dxb'));
        expect(i, isA<PreFillIntent>());
      });
    });

    group('SearchIntent', () {
      test('from + to + date → SearchIntent', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB&date=2025-08-15'));
        expect(i, isA<SearchIntent>());
      });

      test('criteria origin IATA is BOM', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB&date=2025-08-15'))
            as SearchIntent;
        expect(i.criteria.origin?.iata, 'BOM');
      });

      test('criteria destination IATA is DXB', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB&date=2025-08-15'))
            as SearchIntent;
        expect(i.criteria.destination?.iata, 'DXB');
      });

      test('criteria departureDate is 2025-08-15', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB&date=2025-08-15'))
            as SearchIntent;
        expect(i.criteria.departureDate, DateTime(2025, 8, 15));
      });

      test('DEL→LHR with date → SearchIntent', () {
        final i = _r.resolve(
            _uri('?from=DEL&to=LHR&date=2025-09-01'));
        expect(i, isA<SearchIntent>());
        final s = i as SearchIntent;
        expect(s.criteria.origin?.iata, 'DEL');
        expect(s.criteria.destination?.iata, 'LHR');
      });

      test('date year boundary 2020 valid', () {
        final i = _r.resolve(_uri('?from=BOM&to=DXB&date=2020-01-01'));
        expect(i, isA<SearchIntent>());
      });
    });

  });
}

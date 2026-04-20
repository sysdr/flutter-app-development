import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';

void main() {
  test('Breakpoints style boundaries', () {
    expect(Breakpoints.styleFor(500), isA<CompactNav>());
    expect(Breakpoints.styleFor(600), isA<MediumNav>());
    expect(Breakpoints.styleFor(900), isA<ExpandedNav>());
  });
}

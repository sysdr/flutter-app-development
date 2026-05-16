import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_24/core/transitions/transition_config.dart';

void main() {
  group('TransitionConfig', () {
    group('durations', () {
      test('enterDuration is a Duration', () {
        expect(TransitionConfig.enterDuration, isA<Duration>());
      });
      test('exitDuration is a Duration', () {
        expect(TransitionConfig.exitDuration, isA<Duration>());
      });
      test('heroDuration is a Duration', () {
        expect(TransitionConfig.heroDuration, isA<Duration>());
      });
      test('enterDuration is positive and < 600ms', () {
        expect(TransitionConfig.enterDuration.inMilliseconds,
            inInclusiveRange(50, 600));
      });
      test('exitDuration is positive and < 600ms', () {
        expect(TransitionConfig.exitDuration.inMilliseconds,
            inInclusiveRange(50, 600));
      });
      test('exitDuration <= enterDuration (exits are faster)', () {
        expect(
          TransitionConfig.exitDuration.inMilliseconds,
          lessThanOrEqualTo(
              TransitionConfig.enterDuration.inMilliseconds));
      });
      test('heroDuration is positive', () {
        expect(TransitionConfig.heroDuration.inMilliseconds,
            greaterThan(0));
      });
      test('defaultCurve is a Curve instance', () {
        expect(TransitionConfig.defaultCurve, isA<Curve>());
      });
    });
  });
}

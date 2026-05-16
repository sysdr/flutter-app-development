import 'package:flutter/material.dart';
import 'transition_config.dart';

abstract final class NomadTransitions {
  static Widget slideUp(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end:   Offset.zero,
    ).chain(CurveTween(curve: TransitionConfig.defaultCurve));

    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: animation.drive(
            CurveTween(curve: TransitionConfig.defaultCurve)),
        child: child));
  }

  static Widget fadeScale(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scaleTween = Tween<double>(begin: 0.95, end: 1.0)
        .chain(CurveTween(curve: TransitionConfig.defaultCurve));
    final fadeTween  = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: TransitionConfig.defaultCurve));

    return ScaleTransition(
      scale: animation.drive(scaleTween),
      child: FadeTransition(
        opacity: animation.drive(fadeTween),
        child: child));
  }

  static Widget slideRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final tween = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end:   Offset.zero,
    ).chain(CurveTween(curve: TransitionConfig.defaultCurve));

    return SlideTransition(
      position: animation.drive(tween),
      child: FadeTransition(
        opacity: animation.drive(
            CurveTween(curve: TransitionConfig.defaultCurve)),
        child: child));
  }
}

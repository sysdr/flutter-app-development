import 'package:flutter/material.dart';
import 'transition_config.dart';

// Named page-transition builders for GoRouter CustomTransitionPage.
//
// All builders have the standard signature required by GoRouter:
//   Widget Function(
//     BuildContext, Animation<double>, Animation<double>, Widget)
//
// Usage in AppRouter:
//   pageBuilder: (ctx, state) => CustomTransitionPage(
//     key:          state.pageKey,
//     child:        FlightDetailScreen(flight: f),
//     transitionDuration: TransitionConfig.enterDuration,
//     transitionsBuilder: NomadTransitions.slideUp,
//   ),
abstract final class NomadTransitions {
  // Slides in from bottom (modal-style detail screens)
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

  // Fades in while scaling from 95% → 100% (used for modal overlays)
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

  // Slides in from right (lateral navigation)
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

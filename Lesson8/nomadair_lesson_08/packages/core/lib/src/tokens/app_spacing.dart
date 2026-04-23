abstract final class AppSpacing {
  static const double xs=4.0,sm=8.0,md=16.0,lg=24.0,xl=32.0,xxl=48.0;
  static const double radiusSm=8.0,radiusMd=12.0,radiusLg=20.0,radiusFull=999.0;
  /// WCAG 2.5.5 minimum interactive target: 44 CSS px.
  /// Material Design minimum: 48 dp. NomadAir uses the stricter Material value.
  static const double minTouchTarget=48.0;
}

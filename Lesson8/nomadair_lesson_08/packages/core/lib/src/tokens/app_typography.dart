import 'package:flutter/material.dart';
abstract final class AppTypography {
  static const String _sans='Roboto'; static const String _mono='monospace';
  static const TextStyle displayLarge=TextStyle(fontFamily:_sans,fontSize:34,fontWeight:FontWeight.w700,letterSpacing:-1.0,height:1.2);
  static const TextStyle headlineLarge=TextStyle(fontFamily:_sans,fontSize:24,fontWeight:FontWeight.w700,height:1.3);
  static const TextStyle headlineMedium=TextStyle(fontFamily:_sans,fontSize:20,fontWeight:FontWeight.w600,height:1.35);
  static const TextStyle headlineSmall=TextStyle(fontFamily:_sans,fontSize:18,fontWeight:FontWeight.w600,height:1.4);
  static const TextStyle bodyLarge=TextStyle(fontFamily:_sans,fontSize:16,fontWeight:FontWeight.w400,height:1.5);
  static const TextStyle bodyMedium=TextStyle(fontFamily:_sans,fontSize:14,fontWeight:FontWeight.w400,height:1.5,letterSpacing:0.1);
  static const TextStyle bodySmall=TextStyle(fontFamily:_sans,fontSize:12,fontWeight:FontWeight.w400,height:1.4,letterSpacing:0.4);
  static const TextStyle labelLarge=TextStyle(fontFamily:_sans,fontSize:14,fontWeight:FontWeight.w600,letterSpacing:0.1);
  static const TextStyle labelMedium=TextStyle(fontFamily:_sans,fontSize:12,fontWeight:FontWeight.w500,letterSpacing:0.5);
  static const TextStyle monoMedium=TextStyle(fontFamily:_mono,fontSize:13,fontWeight:FontWeight.w400,letterSpacing:0.5);
  static const TextStyle monoSmall=TextStyle(fontFamily:_mono,fontSize:11,fontWeight:FontWeight.w400,letterSpacing:0.5);
}

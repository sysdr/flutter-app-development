import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/nomad_theme_extension.dart';
abstract final class NomadAirTheme{static ThemeData light()=>_b(Brightness.light,NomadThemeExtension.light,AppColors.grey50);static ThemeData dark()=>_b(Brightness.dark,NomadThemeExtension.dark,AppColors.darkBackground);static ThemeData _b(Brightness b,NomadThemeExtension ext,Color sc)=>ThemeData(useMaterial3:true,colorScheme:ColorScheme.fromSeed(seedColor:AppColors.blue600,brightness:b),scaffoldBackgroundColor:sc,extensions:<ThemeExtension<dynamic>>[ext],dividerTheme:DividerThemeData(color:ext.dividerColor,thickness:1),cardTheme:const CardThemeData(elevation:0,margin:EdgeInsets.zero,shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(AppSpacing.radiusMd)))));}

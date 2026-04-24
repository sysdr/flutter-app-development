import 'package:flutter/material.dart';
import 'app_colors.dart';

sealed class WcagLevel{const WcagLevel(this.label);final String label;}
final class WcagAAA     extends WcagLevel{const WcagAAA()     :super('AAA');}
final class WcagAA      extends WcagLevel{const WcagAA()      :super('AA');}
final class WcagAALarge extends WcagLevel{const WcagAALarge() :super('AA Large');}
final class WcagFail    extends WcagLevel{const WcagFail()    :super('Fail');}

final class NomadThemeExtension extends ThemeExtension<NomadThemeExtension>{
  const NomadThemeExtension({
    required this.brandPrimary,required this.brandSecondary,
    required this.brandAccent,required this.surfaceColor,
    required this.onSurfaceColor,required this.successColor,
    required this.errorColor,required this.warningColor,
    required this.imageOverlayColor,required this.iconAdaptiveColor,
    required this.dividerColor,
  });
  final Color brandPrimary,brandSecondary,brandAccent;
  final Color surfaceColor,onSurfaceColor;
  final Color successColor,errorColor,warningColor;
  final Color imageOverlayColor,iconAdaptiveColor,dividerColor;

  static const NomadThemeExtension light=NomadThemeExtension(
    brandPrimary:AppColors.blue600,brandSecondary:AppColors.green500,
    brandAccent:AppColors.amber600,surfaceColor:AppColors.white,
    onSurfaceColor:AppColors.grey900,successColor:AppColors.green500,
    errorColor:AppColors.red500,warningColor:AppColors.amber700,
    imageOverlayColor:Colors.transparent,
    iconAdaptiveColor:AppColors.grey700,dividerColor:AppColors.grey200,
  );
  static const NomadThemeExtension dark=NomadThemeExtension(
    brandPrimary:AppColors.blue300,brandSecondary:AppColors.green300,
    brandAccent:AppColors.amber300,surfaceColor:AppColors.darkSurface,
    onSurfaceColor:AppColors.grey200,successColor:AppColors.green300,
    errorColor:Color(0xFFFF7B72),warningColor:AppColors.amber300,
    imageOverlayColor:Color(0x661A1A2E),
    iconAdaptiveColor:AppColors.grey200,dividerColor:AppColors.darkDivider,
  );

  @override
  NomadThemeExtension copyWith({
    Color? brandPrimary,Color? brandSecondary,Color? brandAccent,
    Color? surfaceColor,Color? onSurfaceColor,
    Color? successColor,Color? errorColor,Color? warningColor,
    Color? imageOverlayColor,Color? iconAdaptiveColor,Color? dividerColor,
  })=>NomadThemeExtension(
    brandPrimary:brandPrimary??this.brandPrimary,
    brandSecondary:brandSecondary??this.brandSecondary,
    brandAccent:brandAccent??this.brandAccent,
    surfaceColor:surfaceColor??this.surfaceColor,
    onSurfaceColor:onSurfaceColor??this.onSurfaceColor,
    successColor:successColor??this.successColor,
    errorColor:errorColor??this.errorColor,
    warningColor:warningColor??this.warningColor,
    imageOverlayColor:imageOverlayColor??this.imageOverlayColor,
    iconAdaptiveColor:iconAdaptiveColor??this.iconAdaptiveColor,
    dividerColor:dividerColor??this.dividerColor,
  );

  @override
  NomadThemeExtension lerp(NomadThemeExtension? o,double t){
    if(o==null)return this;
    return NomadThemeExtension(
      brandPrimary:Color.lerp(brandPrimary,o.brandPrimary,t)!,
      brandSecondary:Color.lerp(brandSecondary,o.brandSecondary,t)!,
      brandAccent:Color.lerp(brandAccent,o.brandAccent,t)!,
      surfaceColor:Color.lerp(surfaceColor,o.surfaceColor,t)!,
      onSurfaceColor:Color.lerp(onSurfaceColor,o.onSurfaceColor,t)!,
      successColor:Color.lerp(successColor,o.successColor,t)!,
      errorColor:Color.lerp(errorColor,o.errorColor,t)!,
      warningColor:Color.lerp(warningColor,o.warningColor,t)!,
      imageOverlayColor:Color.lerp(imageOverlayColor,o.imageOverlayColor,t)!,
      iconAdaptiveColor:Color.lerp(iconAdaptiveColor,o.iconAdaptiveColor,t)!,
      dividerColor:Color.lerp(dividerColor,o.dividerColor,t)!,
    );
  }
}

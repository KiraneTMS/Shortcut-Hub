import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? firstGradientColor;
  final Color? secondGradientColor;
  final Color? thirdGradientColor;

  const CustomThemeExtension({
    this.firstGradientColor,
    this.secondGradientColor,
    this.thirdGradientColor,
  });

  @override
  CustomThemeExtension copyWith({
    Color? firstGradientColor,
    Color? secondGradientColor,
    Color? thirdGradientColor,
  }) {
    return CustomThemeExtension(
      firstGradientColor: firstGradientColor ?? this.firstGradientColor,
      secondGradientColor: secondGradientColor ?? this.secondGradientColor,
      thirdGradientColor: thirdGradientColor ?? this.thirdGradientColor,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      firstGradientColor: Color.lerp(firstGradientColor, other.firstGradientColor, t),
      secondGradientColor: Color.lerp(secondGradientColor, other.secondGradientColor, t),
      thirdGradientColor: Color.lerp(thirdGradientColor, other.thirdGradientColor, t),
    );
  }
}
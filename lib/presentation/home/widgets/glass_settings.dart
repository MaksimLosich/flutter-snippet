import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as glass;

import '../../utils/theme_extensions.dart';

glass.LiquidGlassSettings buildActionGlassSettings(BuildContext context) {
  return glass.LiquidGlassSettings.figma(
    glassColor: context.appColors.glassBgWhite20,
    lightAngle: -math.pi / 4,
    lightIntensity: 80,
    refraction: 80,
    depth: 20,
    dispersion: 50,
    frost: 24,
  );
}

glass.LiquidGlassSettings buildToolbarGlassSettings(BuildContext context) {
  return glass.LiquidGlassSettings.figma(
    glassColor: context.appColors.glassBgWhite20,
    lightAngle: -math.pi / 4,
    lightIntensity: 80,
    refraction: 29,
    depth: 17,
    dispersion: 50,
    frost: 10,
  );
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../utils/dimens.dart';
import '../../utils/theme_extensions.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.onPressed,
    required this.assetUrl,
    this.size = AppDimens.searchButtonSize,
    super.key,
  });

  final VoidCallback onPressed;
  final String assetUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final settings = LiquidGlassSettings.figma(
      glassColor: context.appColors.glassBgWhite20,
      lightAngle: -math.pi / 4,
      lightIntensity: 80,
      refraction: 29,
      depth: 17,
      dispersion: 50,
      frost: 10,
    );

    return GlassButton.custom(
      onTap: onPressed,
      width: size,
      height: size,
      alignment: Alignment.center,
      useOwnLayer: true,
      shape: const LiquidOval(),
      settings: settings,
      child: SvgPicture.asset(assetUrl),
    );
  }
}

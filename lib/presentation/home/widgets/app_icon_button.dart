import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../utils/dimens.dart';
import 'glass_settings.dart';

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
    return GlassButton.custom(
      onTap: onPressed,
      width: size,
      height: size,
      alignment: Alignment.center,
      useOwnLayer: true,
      shape: const LiquidOval(),
      settings: buildToolbarGlassSettings(context),
      child: SvgPicture.asset(assetUrl),
    );
  }
}

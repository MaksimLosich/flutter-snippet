import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

import 'glass_settings.dart';

class AppGlassButton extends StatelessWidget {
  const AppGlassButton.withPadding({super.key, required this.assetUrl, required this.title, required this.onPressed})
    : horizontalPadding = AppDimens.padding20,
      width = null;

  const AppGlassButton.tight({super.key, required this.assetUrl, required this.title, required this.onPressed})
    : horizontalPadding = 0,
      width = 128.0;

  final String assetUrl;
  final String title;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final double? width;

  @override
  Widget build(BuildContext context) {
    const assetSize = 24.0;
    final appColors = context.appColors;

    return UnconstrainedBox(
      child: SizedBox(
        width: width,
        child: GlassButton.custom(
          onTap: onPressed,
          alignment: Alignment.center,
          useOwnLayer: true,
          shape: const LiquidRoundedRectangle(borderRadius: AppDimens.radiusFull),
          settings: buildActionGlassSettings(context),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: AppDimens.padding16),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Image.asset(assetUrl, width: assetSize, height: assetSize),
                  const SizedBox(width: AppDimens.padding8),
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: .w700, color: appColors.buttonText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

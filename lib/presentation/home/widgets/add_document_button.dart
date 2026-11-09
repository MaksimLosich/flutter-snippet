import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as glass;
import 'package:test_task/l10n/l10n_extension.dart';

import '../../utils/dimens.dart';
import '../../utils/theme_extensions.dart';
import 'glass_settings.dart';

class AddDocumentButton extends StatelessWidget {
  const AddDocumentButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    const height = 61.0;
    const iconSize = 25.0;

    return UnconstrainedBox(
      child: glass.GlassButton.custom(
        onTap: onPressed,
        height: height,
        alignment: Alignment.center,
        useOwnLayer: true,
        shape: const glass.LiquidRoundedRectangle(borderRadius: AppDimens.radiusFull),
        settings: buildActionGlassSettings(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [appColors.addDocumentGradientStart, appColors.addDocumentGradientEnd],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle, color: context.appColors.onSurfaceText, size: iconSize),
                  const SizedBox(width: AppDimens.padding8),
                  Text(
                    context.localization.homeActionsAddDocument,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: appColors.onSurfaceText,
                      fontWeight: FontWeight.w800,
                    ),
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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/l10n/l10n_extension.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/home/widgets/app_glass_button.dart';
import 'package:test_task/presentation/home/widgets/app_icon_button.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

class AddDocumentOverlay extends StatelessWidget {
  const AddDocumentOverlay({
    super.key,
    required this.onClose,
    required this.onFilesPressed,
    required this.onPhotosPressed,
    required this.onScannerPressed,
  });

  final VoidCallback onClose;
  final VoidCallback onFilesPressed;
  final VoidCallback onPhotosPressed;
  final VoidCallback onScannerPressed;

  @override
  Widget build(BuildContext context) {
    const rightPadding = 16.1;

    const settings = LiquidGlassSettings.figma(
      glassColor: Color(0x00FFFFFF),
      lightAngle: -math.pi / 4,
      lightIntensity: 0,
      refraction: 2,
      depth: 62,
      dispersion: 49,
      frost: 10,
    );

    return GlassContainer(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      settings: settings,
      useOwnLayer: true,
      shape: const LiquidVerticalRoundedRectangle(topRadius: AppDimens.radius36, bottomRadius: 0),
      child: Align(
        alignment: .bottomRight,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + AppDimens.floatingToolbarPadding),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: AppDimens.padding28),
                child: Column(
                  mainAxisSize: .min,
                  spacing: AppDimens.padding12,
                  children: [
                    AppGlassButton.tight(
                      assetUrl: HomeAssets.files,
                      title: context.localization.homeSourcesFiles,
                      onPressed: onFilesPressed,
                    ),
                    AppGlassButton.tight(
                      assetUrl: HomeAssets.photos,
                      title: context.localization.homeSourcesPhotos,
                      onPressed: onPhotosPressed,
                    ),
                    AppGlassButton.tight(
                      assetUrl: HomeAssets.scanner,
                      title: context.localization.homeSourcesScanner,
                      onPressed: onScannerPressed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.padding12),
              Padding(
                padding: const EdgeInsets.only(right: rightPadding),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      context.localization.homeActionsAddDocumentFrom,
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: .w700, height: 1.2),
                    ),
                    const SizedBox(width: AppDimens.padding16),
                    AppIconButton(
                      onPressed: onClose,
                      assetUrl: HomeAssets.close,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

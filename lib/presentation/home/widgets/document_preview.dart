import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

class DocumentPreview extends StatelessWidget {
  const DocumentPreview({required this.document, required this.isSelectMode, required this.isSelected, super.key});

  static const _designWidth = 123.72;
  static const _designHeight = 167.84;
  static const _pageWidthRatio = _designWidth / AppDimens.documentCardDesignWidth;
  static const _aspectRatio = _designWidth / _designHeight;
  static const _secondPageDesignOffset = 11.0;
  static const _secondPageOffsetRatio = _secondPageDesignOffset / AppDimens.documentCardDesignWidth;
  static const _secondPageAngle = 7.35 * math.pi / 180;
  static const _secondPageShadowOffset = Offset(0, 4);
  static const _secondPageShadowBlurRadius = 11.1;
  static const _signedBadgeSize = 42.0;
  static const _signedBadgeYOffset = AppDimens.padding8;

  final AppDocument document;
  final bool isSelectMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final pageWidth = cardWidth * _pageWidthRatio;
        final pageHeight = pageWidth / _aspectRatio;
        final secondPageOffset = cardWidth * _secondPageOffsetRatio;
        final lastPreviewPath = document.lastPreviewPath;

        return SizedBox(
          width: pageWidth + (lastPreviewPath == null ? 0 : secondPageOffset),
          height: pageHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                right: lastPreviewPath == null ? 0 : secondPageOffset,
                child: _DocumentPreviewPage(path: document.firstPreviewPath),
              ),
              if (lastPreviewPath != null)
                Positioned(
                  left: secondPageOffset,
                  top: 0,
                  width: pageWidth,
                  height: pageHeight,
                  child: Transform.rotate(
                    angle: _secondPageAngle,
                    child: _DocumentPreviewPage(
                      path: lastPreviewPath,
                      boxShadow: [
                        BoxShadow(
                          offset: _secondPageShadowOffset,
                          blurRadius: _secondPageShadowBlurRadius,
                          color: context.appColors.documentPreviewShadow,
                        ),
                      ],
                    ),
                  ),
                ),
              if (document.isSigned)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(offset: const Offset(0, _signedBadgeYOffset), child: const _SignedBadge()),
                ),
              if (isSelectMode)
                Align(
                  alignment: Alignment.center,
                  child: _SelectionIndicator(isSelected: isSelected),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  static const _size = 42.0;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Image.asset(isSelected ? HomeAssets.selected : HomeAssets.unselected, width: _size, height: _size);
  }
}

class _SignedBadge extends StatelessWidget {
  const _SignedBadge();

  @override
  Widget build(BuildContext context) {
    final settings = LiquidGlassSettings.figma(
      glassColor: context.appColors.documentSignedBadgeFill,
      lightAngle: -math.pi / 4,
      lightIntensity: 80,
      refraction: 0,
      depth: 20,
      dispersion: 50,
      frost: 25,
    );

    return GlassContainer(
      width: DocumentPreview._signedBadgeSize,
      height: DocumentPreview._signedBadgeSize,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      settings: settings,
      useOwnLayer: true,
      shape: const LiquidOval(),
      child: SvgPicture.asset(HomeAssets.sign),
    );
  }
}

class _DocumentPreviewPage extends StatelessWidget {
  const _DocumentPreviewPage({required this.path, this.boxShadow = const []});

  static const _fallbackIconSize = 32.0;

  final String path;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.secondaryBg,
        borderRadius: BorderRadius.circular(AppDimens.padding12),
        border: Border.all(color: context.appColors.documentPreviewBorder),
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.padding12),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: context.appColors.secondaryBg,
              child: Center(
                child: Icon(Icons.picture_as_pdf, color: context.appColors.documentDateText, size: _fallbackIconSize),
              ),
            );
          },
        ),
      ),
    );
  }
}

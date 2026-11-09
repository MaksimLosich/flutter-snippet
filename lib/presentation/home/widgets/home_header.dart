import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/l10n/l10n_extension.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/home/widgets/logo.dart';
import 'package:test_task/presentation/home/widgets/more_button.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.isSelectMode,
    required this.areAllDocumentsSelected,
    required this.selectedDocumentCount,
    required this.onToggleAllSelection,
    required this.onExitSelectMode,
    required this.onSelectPressed,
    required this.onAddDocumentPressed,
  });

  final bool isSelectMode;
  final bool areAllDocumentsSelected;
  final int selectedDocumentCount;
  final VoidCallback onToggleAllSelection;
  final VoidCallback onExitSelectMode;
  final VoidCallback onSelectPressed;
  final VoidCallback onAddDocumentPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.padding18,
        right: AppDimens.padding16,
        top: AppDimens.padding12,
        bottom: AppDimens.padding16,
      ),
      child: Row(
        children: isSelectMode
            ? [
                _SelectAllButton(
                  areAllDocumentsSelected: areAllDocumentsSelected,
                  selectedDocumentCount: selectedDocumentCount,
                  onPressed: onToggleAllSelection,
                ),
                const Spacer(),
                _SelectModeCloseButton(onPressed: onExitSelectMode),
              ]
            : [
                const Logo(),
                const Spacer(),
                MoreButton(onSelectPressed: onSelectPressed, onAddDocumentPressed: onAddDocumentPressed),
              ],
      ),
    );
  }
}

class _SelectAllButton extends StatelessWidget {
  const _SelectAllButton({
    required this.areAllDocumentsSelected,
    required this.selectedDocumentCount,
    required this.onPressed,
  });

  static const _fontSize = 14.0;
  static const _height = 18 / 14;

  final bool areAllDocumentsSelected;
  final int selectedDocumentCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final text = areAllDocumentsSelected
        ? context.localization.homeSelectionDeselectAll(selectedDocumentCount)
        : context.localization.homeSelectionSelectAll;

    return GlassButton.custom(
      onTap: onPressed,
      useOwnLayer: true,
      shape: const LiquidRoundedRectangle(borderRadius: AppDimens.radiusFull),
      settings: _buildSelectionHeaderGlassSettings(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding12, vertical: AppDimens.padding10),
        child: Text(
          text,
          style: context.textTheme.titleSmall?.copyWith(
            color: context.appColors.secondaryText,
            fontWeight: FontWeight.w700,
            fontSize: _fontSize,
            height: _height,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _SelectModeCloseButton extends StatelessWidget {
  const _SelectModeCloseButton({required this.onPressed});

  static const _iconSize = 22.0;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      onTap: onPressed,
      width: AppDimens.moreButtonSize,
      height: AppDimens.moreButtonSize,
      alignment: Alignment.center,
      useOwnLayer: true,
      shape: const LiquidRoundedRectangle(borderRadius: AppDimens.moreButtonRadius),
      settings: _buildSelectionHeaderGlassSettings(context),
      child: SvgPicture.asset(
        HomeAssets.close,
        width: _iconSize,
        height: _iconSize,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}

LiquidGlassSettings _buildSelectionHeaderGlassSettings(BuildContext context) {
  return LiquidGlassSettings.figma(
    glassColor: context.appColors.glassBgWhite10,
    lightAngle: -math.pi / 4,
    lightIntensity: 27,
    refraction: 57,
    depth: 1.27,
    dispersion: 21,
    frost: 0,
  );
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/l10n/l10n_extension.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/home/widgets/share_position_origin.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

const _contextMenuIconSize = 22.0;

class DocumentActionsOverlay extends StatelessWidget {
  const DocumentActionsOverlay({
    super.key,
    required this.document,
    required this.anchor,
    required this.onDismiss,
    required this.onPrintPressed,
    required this.onSharePressed,
    required this.onDeletePressed,
  });

  final AppDocument document;
  final Offset? anchor;
  final VoidCallback onDismiss;
  final VoidCallback onPrintPressed;
  final ValueChanged<Rect> onSharePressed;
  final VoidCallback onDeletePressed;

  static const _anchorGap = AppDimens.padding12;
  static const _estimatedMenuHeight = 180.0;
  static const _edgePadding = AppDimens.padding12;
  static const _maxWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: document.title,
      container: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onDismiss,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final overlayBox = context.findRenderObject() as RenderBox?;
            final menuRect = _menuRect(constraints, overlayBox, MediaQuery.paddingOf(context).bottom);

            return Stack(
              children: [
                Positioned(
                  left: menuRect.left,
                  top: menuRect.top,
                  child: GestureDetector(
                    onTap: () {},
                    child: GlassContainer(
                      width: menuRect.width,
                      clipBehavior: Clip.antiAlias,
                      settings: _buildDocumentContextMenuSettings(context),
                      useOwnLayer: true,
                      shape: const LiquidRoundedRectangle(borderRadius: AppDimens.radius34),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: AppDimens.padding32,
                              right: AppDimens.padding32,
                              top: AppDimens.padding32,
                              bottom: AppDimens.padding28,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _DocumentContextPrimaryAction(
                                    assetUrl: HomeAssets.print,
                                    title: context.localization.homeDocumentActionsPrint,
                                    onTap: onPrintPressed,
                                  ),
                                ),
                                const SizedBox(width: AppDimens.padding24),
                                Expanded(
                                  child: Builder(
                                    builder: (shareButtonContext) => _DocumentContextPrimaryAction(
                                      assetUrl: HomeAssets.share2,
                                      title: context.localization.homeDocumentActionsShare,
                                      onTap: () => onSharePressed(sharePositionOrigin(shareButtonContext)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding32),
                            child: Divider(height: 1, thickness: 1, color: context.appColors.documentContextSeparator),
                          ),
                          _DocumentContextDeleteAction(onTap: onDeletePressed),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Rect _menuRect(BoxConstraints constraints, RenderBox? overlayBox, double bottomInset) {
    final globalAnchor = anchor;
    final localAnchor = globalAnchor == null || overlayBox == null
        ? Offset(constraints.maxWidth / 2, constraints.maxHeight / 2)
        : overlayBox.globalToLocal(globalAnchor);
    final width = math.min(constraints.maxWidth - _edgePadding * 2, _maxWidth);
    final bottomLimit = constraints.maxHeight - bottomInset - _edgePadding;
    final preferredTop = localAnchor.dy + _anchorGap;
    final fallbackTop = localAnchor.dy - _estimatedMenuHeight - _anchorGap;
    final menuTop = preferredTop + _estimatedMenuHeight <= bottomLimit ? preferredTop : fallbackTop;
    final left = (localAnchor.dx - width / 2)
        .clamp(_edgePadding, constraints.maxWidth - width - _edgePadding)
        .toDouble();
    final top = menuTop.clamp(_edgePadding, math.max(_edgePadding, bottomLimit - _estimatedMenuHeight)).toDouble();
    return Rect.fromLTWH(left, top, width, _estimatedMenuHeight);
  }
}

LiquidGlassSettings _buildDocumentContextMenuSettings(BuildContext context) {
  return LiquidGlassSettings.figma(
    glassColor: context.appColors.glassMenuFill,
    lightAngle: -math.pi / 4,
    lightIntensity: 90,
    refraction: 60,
    depth: 60,
    dispersion: 0,
    frost: 20,
  );
}

class _DocumentContextPrimaryAction extends StatelessWidget {
  const _DocumentContextPrimaryAction({required this.assetUrl, required this.title, required this.onTap});

  static const _titleFontSize = 12.0;
  static const _titleHeight = 18 / 12;

  final String assetUrl;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetUrl,
            width: _contextMenuIconSize,
            height: _contextMenuIconSize,
            colorFilter: ColorFilter.mode(context.appColors.menuText, BlendMode.srcIn),
          ),
          const SizedBox(height: AppDimens.padding8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.appColors.menuText,
              fontSize: _titleFontSize,
              height: _titleHeight,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentContextDeleteAction extends StatelessWidget {
  const _DocumentContextDeleteAction({required this.onTap});

  static const _titleFontSize = 17.0;
  static const _titleHeight = 20 / 17;
  static const _letterSpacing = -0.43;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding32, vertical: AppDimens.padding24),
        child: Row(
          children: [
            SvgPicture.asset(
              HomeAssets.delete2,
              width: _contextMenuIconSize,
              height: _contextMenuIconSize,
              colorFilter: ColorFilter.mode(context.appColors.dangerText, BlendMode.srcIn),
            ),
            const SizedBox(width: AppDimens.padding16),
            Text(
              context.localization.homeDocumentActionsDelete,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.appColors.dangerText,
                fontSize: _titleFontSize,
                height: _titleHeight,
                fontWeight: FontWeight.w400,
                letterSpacing: _letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

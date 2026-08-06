import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/presentation/utils/dimens.dart';

import '../../utils/theme_extensions.dart';
import '../assets.dart';

class MoreButton extends StatefulWidget {
  const MoreButton({
    super.key,
    this.onSelectPressed,
    this.onAddDocumentPressed,
  });

  final VoidCallback? onSelectPressed;
  final VoidCallback? onAddDocumentPressed;

  @override
  State<MoreButton> createState() => _MoreButtonState();
}

class _MoreButtonState extends State<MoreButton> {
  final _overlayController = OverlayPortalController();
  final _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final buttonSettings = LiquidGlassSettings.figma(
      glassColor: context.appColors.glassBgWhite10,
      lightAngle: -math.pi / 4,
      lightIntensity: 27,
      refraction: 57,
      depth: 1.27,
      dispersion: 21,
      frost: 0,
    );

    final menuSettings = LiquidGlassSettings.figma(
      glassColor: context.appColors.glassMenuFill,
      lightAngle: -math.pi / 4,
      lightIntensity: 90,
      refraction: 60,
      depth: 60,
      dispersion: 0,
      frost: 20,
    );

    return OverlayPortal(
      controller: _overlayController,
      overlayLocation: OverlayChildLocation.rootOverlay,
      overlayChildBuilder: (context) {
        return _MorePopoverOverlay(
          layerLink: _layerLink,
          settings: menuSettings,
          onDismiss: _overlayController.hide,
          onSelectPressed: widget.onSelectPressed,
          onAddDocumentPressed: widget.onAddDocumentPressed,
        );
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GlassIconButton(
          size: AppDimens.moreButtonSize,
          icon: SvgPicture.asset(HomeAssets.dots),
          onPressed: _overlayController.toggle,
          useOwnLayer: true,
          shape: GlassIconButtonShape.roundedSquare,
          borderRadius: AppDimens.moreButtonRadius,
          settings: buttonSettings,
          semanticLabel: 'home.menu.more'.tr(),
        ),
      ),
    );
  }
}

class _MorePopoverOverlay extends StatelessWidget {
  const _MorePopoverOverlay({
    required this.layerLink,
    required this.settings,
    required this.onDismiss,
    required this.onSelectPressed,
    required this.onAddDocumentPressed,
  });

  final LayerLink layerLink;
  final LiquidGlassSettings settings;
  final VoidCallback onDismiss;
  final VoidCallback? onSelectPressed;
  final VoidCallback? onAddDocumentPressed;

  @override
  Widget build(BuildContext context) {
    final width = 262.0;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDismiss,
            child: const SizedBox.expand(),
          ),
        ),
        CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 12),
          child: Material(
            color: Colors.transparent,
            child: GlassContainer(
              width: width,
              clipBehavior: Clip.antiAlias,
              shape: const LiquidRoundedRectangle(
                borderRadius: AppDimens.radius34,
              ),
              settings: settings,
              useOwnLayer: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MorePopoverAction(
                      icon: Icons.check_circle_outline,
                      title: 'home.menu.select'.tr(),
                      onTap: () {
                        onDismiss();
                        onSelectPressed?.call();
                      },
                    ),
                    _MorePopoverAction(
                      icon: Icons.add_circle,
                      title: 'home.menu.addDocument'.tr(),
                      onTap: () {
                        onDismiss();
                        onAddDocumentPressed?.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MorePopoverAction extends StatelessWidget {
  const _MorePopoverAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const iconSize = 22.0;
    const iconPadding = 3.0;
    const paddingLeft = 40.0;
    const paddingRight = 20.0;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: paddingLeft, right: paddingRight),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: iconPadding),
              child: Icon(
                icon,
                size: iconSize,
                color: context.appColors.menuText,
              ),
            ),
            const SizedBox(width: AppDimens.padding8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.padding10,
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.menuText,
                    fontSize: 17,
                    height: 20 / 17,
                    letterSpacing: -0.43,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

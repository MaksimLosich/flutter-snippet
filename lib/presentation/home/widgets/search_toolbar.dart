import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/l10n/l10n_extension.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/home/widgets/add_document_button.dart';
import 'package:test_task/presentation/home/widgets/app_icon_button.dart';
import 'package:test_task/presentation/home/widgets/glass_settings.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

const _closeButtonSize = 48.0;
const _searchFieldHeight = 48.0;
const _searchFieldIconSize = 26.0;
const _searchFieldClearIconSize = 18.0;

class SearchMorphToolbar extends StatelessWidget {
  const SearchMorphToolbar({
    super.key,
    required this.isSearchVisible,
    required this.onSearchPressed,
    required this.onAddDocumentPressed,
    required this.onChanged,
    required this.onClose,
  });

  static const _duration = Duration(milliseconds: 360);
  static const _spacing = AppDimens.padding12;

  final bool isSearchVisible;
  final VoidCallback onSearchPressed;
  final VoidCallback onAddDocumentPressed;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final settings = buildToolbarGlassSettings(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.padding12,
        right: AppDimens.padding12,
        bottom: MediaQuery.paddingOf(context).bottom + AppDimens.floatingToolbarPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final expandedSearchWidth = math.max(
            AppDimens.searchButtonSize,
            constraints.maxWidth - _spacing - _closeButtonSize,
          );

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: isSearchVisible ? 1 : 0),
            duration: _duration,
            curve: Curves.easeInOutCubic,
            builder: (context, progress, child) {
              return SizedBox(
                height: AppDimens.searchButtonSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _SearchControl(
                      progress: progress,
                      expandedWidth: expandedSearchWidth,
                      isSearchVisible: isSearchVisible,
                      settings: settings,
                      onSearchPressed: onSearchPressed,
                      onChanged: onChanged,
                    ),
                    _AnimatedAddButton(
                      progress: progress,
                      isSearchVisible: isSearchVisible,
                      onPressed: onAddDocumentPressed,
                    ),
                    _AnimatedCloseButton(progress: progress, isSearchVisible: isSearchVisible, onPressed: onClose),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SearchControl extends StatelessWidget {
  const _SearchControl({
    required this.progress,
    required this.expandedWidth,
    required this.isSearchVisible,
    required this.settings,
    required this.onSearchPressed,
    required this.onChanged,
  });

  static const _searchIconFadeStart = 0.12;
  static const _searchIconFadeEnd = 0.52;
  static const _searchIconMoveEnd = 0.36;
  static const _fieldOpacityStart = 0.48;
  static const _fieldPointerStart = 0.86;
  static const _searchIconSize = _searchFieldIconSize;
  static const _searchIconLeftPadding = AppDimens.padding16;

  final double progress;
  final double expandedWidth;
  final bool isSearchVisible;
  final LiquidGlassSettings settings;
  final VoidCallback onSearchPressed;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final searchWidth = _lerp(AppDimens.searchButtonSize, expandedWidth, progress);
    final searchHeight = _lerp(AppDimens.searchButtonSize, _searchFieldHeight, progress);
    final searchTop = (AppDimens.searchButtonSize - searchHeight) / 2;
    final fieldOpacity = Curves.easeInOut.transform(_interval(progress, _fieldOpacityStart, 1));
    final searchIconOpacity =
        1 - Curves.easeInOut.transform(_interval(progress, _searchIconFadeStart, _searchIconFadeEnd));
    final searchIconLeft = _lerp(
      (AppDimens.searchButtonSize - _searchIconSize) / 2,
      _searchIconLeftPadding,
      Curves.easeInOut.transform(_interval(progress, 0, _searchIconMoveEnd)),
    );

    return Positioned(
      left: 0,
      top: searchTop,
      child: SizedBox(
        width: searchWidth,
        height: searchHeight,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                ignoring: isSearchVisible,
                child: GlassButton.custom(
                  onTap: onSearchPressed,
                  width: searchWidth,
                  height: searchHeight,
                  alignment: Alignment.centerLeft,
                  useOwnLayer: true,
                  shape: const LiquidRoundedRectangle(borderRadius: AppDimens.radiusFull),
                  settings: settings,
                  child: Stack(
                    children: [
                      Positioned(
                        left: searchIconLeft,
                        top: (searchHeight - _searchIconSize) / 2,
                        child: Opacity(
                          opacity: searchIconOpacity,
                          child: SvgPicture.asset(HomeAssets.search, width: _searchIconSize, height: _searchIconSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isSearchVisible)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !isSearchVisible || progress < _fieldPointerStart,
                  child: Opacity(
                    opacity: fieldOpacity,
                    child: Align(
                      alignment: Alignment.center,
                      child: _SearchField(onChanged: onChanged, settings: settings),
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

class _AnimatedAddButton extends StatelessWidget {
  const _AnimatedAddButton({required this.progress, required this.isSearchVisible, required this.onPressed});

  static const _slideDistance = 28.0;

  final double progress;
  final bool isSearchVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final opacity = 1 - Curves.easeInOut.transform(_interval(progress, 0.08, 0.78));
    return Positioned(
      right: 0,
      top: 0,
      child: IgnorePointer(
        ignoring: isSearchVisible || progress > 0.05,
        child: Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(progress * _slideDistance, 0),
            child: AddDocumentButton(onPressed: onPressed),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCloseButton extends StatelessWidget {
  const _AnimatedCloseButton({required this.progress, required this.isSearchVisible, required this.onPressed});

  static const _opacityStart = 0.62;
  static const _slideDistance = 10.0;
  static const _startScale = 0.92;

  final double progress;
  final bool isSearchVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final opacity = Curves.easeInOut.transform(_interval(progress, _opacityStart, 1));
    return Positioned(
      right: 0,
      top: (AppDimens.searchButtonSize - _closeButtonSize) / 2,
      child: IgnorePointer(
        ignoring: !isSearchVisible,
        child: Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset((1 - progress) * _slideDistance, 0),
            child: Transform.scale(
              scale: _lerp(_startScale, 1, progress),
              child: AppIconButton(assetUrl: HomeAssets.close, size: _closeButtonSize, onPressed: onPressed),
            ),
          ),
        ),
      ),
    );
  }
}

double _lerp(double start, double end, double progress) {
  return start + (end - start) * progress;
}

double _interval(double value, double start, double end) {
  return ((value - start) / (end - start)).clamp(0.0, 1.0);
}

class _SearchField extends StatefulWidget {
  const _SearchField({required this.onChanged, required this.settings});

  final ValueChanged<String> onChanged;
  final LiquidGlassSettings settings;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _controller = TextEditingController();
  var _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return GlassTextField.search(
      controller: _controller,
      height: _searchFieldHeight,
      autofocus: true,
      placeholder: context.localization.homeActionsSearch,
      prefixIcon: Icon(CupertinoIcons.search, size: _searchFieldIconSize, color: context.appColors.buttonText),
      suffixIcon: _hasText
          ? Icon(
              CupertinoIcons.clear_circled_solid,
              size: _searchFieldClearIconSize,
              color: context.appColors.buttonText,
            )
          : const SizedBox.shrink(),
      onSuffixTap: _hasText ? _clear : null,
      onChanged: widget.onChanged,
      textStyle: context.textTheme.titleMedium?.copyWith(
        color: context.appColors.buttonText,
        fontWeight: FontWeight.w500,
      ),
      placeholderStyle: context.textTheme.titleMedium?.copyWith(
        color: context.appColors.tertiaryText,
        fontWeight: FontWeight.w500,
      ),
      settings: widget.settings,
      useOwnLayer: true,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/home/widgets/app_icon_button.dart';
import 'package:test_task/presentation/home/widgets/share_position_origin.dart';
import 'package:test_task/presentation/utils/dimens.dart';

class SelectionToolbar extends StatelessWidget {
  const SelectionToolbar({required this.onDeletePressed, required this.onSharePressed, super.key});

  static const _buttonSize = 62.0;

  final VoidCallback onDeletePressed;
  final ValueChanged<Rect> onSharePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.padding12,
        right: AppDimens.padding12,
        bottom: MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        children: [
          AppIconButton(assetUrl: HomeAssets.delete, size: _buttonSize, onPressed: onDeletePressed),
          const Spacer(),
          Builder(
            builder: (shareButtonContext) => AppIconButton(
              assetUrl: HomeAssets.share,
              size: _buttonSize,
              onPressed: () => onSharePressed(sharePositionOrigin(shareButtonContext)),
            ),
          ),
        ],
      ),
    );
  }
}

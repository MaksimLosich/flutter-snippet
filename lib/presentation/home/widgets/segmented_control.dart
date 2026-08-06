import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/presentation/home/models/segmented_control_item.dart';

import '../../utils/dimens.dart';
import '../../utils/theme_extensions.dart';

class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    this.groupValue = SegmentedControlItem.all,
    this.onValueChanged,
    super.key,
  });

  final SegmentedControlItem groupValue;
  final ValueChanged<SegmentedControlItem>? onValueChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final selectedIndex = SegmentedControlItem.values.indexOf(groupValue);

    final textStyle = context.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
    );

    return GlassSegmentedControl(
      height: 36,
      borderRadius: AppDimens.radiusFull,
      indicatorBorderRadius: AppDimens.radiusFull,
      padding: const EdgeInsets.all(AppDimens.padding4),
      backgroundColor: appColors.segmentedBackfill,
      indicatorColor: appColors.segmentedControlFill,
      selectedTextStyle: textStyle,
      unselectedTextStyle: textStyle,
      useOwnLayer: true,
      segments: [
        for (final item in SegmentedControlItem.values)
          GlassSegment(label: item.localizationKey.tr()),
      ],
      selectedIndex: selectedIndex,
      onSegmentSelected: (index) {
        onValueChanged?.call(SegmentedControlItem.values[index]);
      },
    );
  }
}

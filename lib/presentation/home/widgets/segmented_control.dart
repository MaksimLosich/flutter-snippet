import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/l10n/l10n_extension.dart';
import 'package:test_task/presentation/home/models/document_filter.dart';

import '../../utils/dimens.dart';
import '../../utils/theme_extensions.dart';

class SegmentedControl extends StatelessWidget {
  const SegmentedControl({required this.groupValue, required this.onValueChanged, super.key});

  final DocumentFilter groupValue;
  final ValueChanged<DocumentFilter> onValueChanged;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final selectedIndex = DocumentFilter.values.indexOf(groupValue);

    final textStyle = context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);

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
        for (final item in DocumentFilter.values)
          GlassSegment(
            label: switch (item) {
              DocumentFilter.all => context.localization.homeFiltersAll,
              DocumentFilter.signed => context.localization.homeFiltersSigned,
              DocumentFilter.unsigned => context.localization.homeFiltersUnsigned,
            },
          ),
      ],
      selectedIndex: selectedIndex,
      onSegmentSelected: (index) {
        onValueChanged(DocumentFilter.values[index]);
      },
    );
  }
}

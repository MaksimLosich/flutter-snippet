import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    const imageSize = 38.0;

    return Row(
      mainAxisSize: .min,
      children: [
        Image.asset(HomeAssets.logo, width: imageSize, height: imageSize),
        const SizedBox(width: AppDimens.padding10),
        Text(
          'app.name'.tr(),
          style: context.textTheme.titleLarge?.copyWith(
            color: context.appColors.secondaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_task/presentation/utils/colors.dart';

abstract class AppTheme {
  static const _fontFamily = 'Inter';
  static const _colors = AppThemeColors.light;

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: _fontFamily,
      useMaterial3: true,
      extensions: const [_colors],
      scaffoldBackgroundColor: _colors.primaryBg,
      textTheme: _buildTextTheme(),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: _colors.primaryText,
      ),
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: _colors.primaryText,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        height: 18 / 14,
        letterSpacing: -0.08,
        fontWeight: FontWeight.w600,
        color: _colors.primaryText,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        height: 1.3,
        fontWeight: FontWeight.w400,
        color: _colors.primaryText,
      ),
    );
  }
}

@immutable
final class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primaryBg,
    required this.secondaryBg,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.buttonText,
    required this.menuText,
    required this.dangerText,
    required this.onSurfaceText,
    required this.documentDateText,
    required this.documentTitleText,
    required this.documentPreviewBorder,
    required this.documentPreviewShadow,
    required this.documentSignedBadgeFill,
    required this.glassBgWhite10,
    required this.glassBgWhite20,
    required this.glassMenuFill,
    required this.segmentedBackfill,
    required this.segmentedControlFill,
    required this.segmentedControlShadow,
    required this.segmentedDivider,
    required this.documentContextSeparator,
    required this.addDocumentGradientStart,
    required this.addDocumentGradientEnd,
  });

  final Color primaryBg;
  final Color secondaryBg;
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;
  final Color buttonText;
  final Color menuText;
  final Color dangerText;
  final Color onSurfaceText;
  final Color documentDateText;
  final Color documentTitleText;
  final Color documentPreviewBorder;
  final Color documentPreviewShadow;
  final Color documentSignedBadgeFill;
  final Color glassBgWhite10;
  final Color glassBgWhite20;
  final Color glassMenuFill;
  final Color segmentedBackfill;
  final Color segmentedControlFill;
  final Color segmentedControlShadow;
  final Color segmentedDivider;
  final Color documentContextSeparator;
  final Color addDocumentGradientStart;
  final Color addDocumentGradientEnd;

  static const light = AppThemeColors(
    primaryBg: AppColors.primaryBg,
    secondaryBg: AppColors.secondaryBg,
    primaryText: AppColors.primaryText,
    secondaryText: AppColors.secondaryText,
    tertiaryText: AppColors.tertiaryText,
    buttonText: AppColors.buttonText,
    menuText: AppColors.menuText,
    dangerText: AppColors.dangerText,
    onSurfaceText: AppColors.onSurfaceText,
    documentDateText: AppColors.documentDateText,
    documentTitleText: AppColors.documentTitleText,
    documentPreviewBorder: AppColors.documentPreviewBorder,
    documentPreviewShadow: AppColors.documentPreviewShadow,
    documentSignedBadgeFill: AppColors.documentSignedBadgeFill,
    glassBgWhite10: AppColors.glassBgWhite10,
    glassBgWhite20: AppColors.glassBgWhite20,
    glassMenuFill: AppColors.glassMenuFill,
    segmentedBackfill: AppColors.segmentedBackfill,
    segmentedControlFill: AppColors.segmentedControlFill,
    segmentedControlShadow: AppColors.segmentedControlShadow,
    segmentedDivider: AppColors.segmentedDivider,
    documentContextSeparator: AppColors.documentContextSeparator,
    addDocumentGradientStart: AppColors.addDocumentGradientStart,
    addDocumentGradientEnd: AppColors.addDocumentGradientEnd,
  );

  @override
  AppThemeColors copyWith({
    Color? primaryBg,
    Color? secondaryBg,
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? buttonText,
    Color? menuText,
    Color? dangerText,
    Color? onSurfaceText,
    Color? documentDateText,
    Color? documentTitleText,
    Color? documentPreviewBorder,
    Color? documentPreviewShadow,
    Color? documentSignedBadgeFill,
    Color? glassBgWhite10,
    Color? glassBgWhite20,
    Color? glassMenuFill,
    Color? segmentedBackfill,
    Color? segmentedControlFill,
    Color? segmentedControlShadow,
    Color? segmentedDivider,
    Color? documentContextSeparator,
    Color? addDocumentGradientStart,
    Color? addDocumentGradientEnd,
  }) {
    return AppThemeColors(
      primaryBg: primaryBg ?? this.primaryBg,
      secondaryBg: secondaryBg ?? this.secondaryBg,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      buttonText: buttonText ?? this.buttonText,
      menuText: menuText ?? this.menuText,
      dangerText: dangerText ?? this.dangerText,
      onSurfaceText: onSurfaceText ?? this.onSurfaceText,
      documentDateText: documentDateText ?? this.documentDateText,
      documentTitleText: documentTitleText ?? this.documentTitleText,
      documentPreviewBorder:
          documentPreviewBorder ?? this.documentPreviewBorder,
      documentPreviewShadow:
          documentPreviewShadow ?? this.documentPreviewShadow,
      documentSignedBadgeFill:
          documentSignedBadgeFill ?? this.documentSignedBadgeFill,
      glassBgWhite10: glassBgWhite10 ?? this.glassBgWhite10,
      glassBgWhite20: glassBgWhite20 ?? this.glassBgWhite20,
      glassMenuFill: glassMenuFill ?? this.glassMenuFill,
      segmentedBackfill: segmentedBackfill ?? this.segmentedBackfill,
      segmentedControlFill: segmentedControlFill ?? this.segmentedControlFill,
      segmentedControlShadow:
          segmentedControlShadow ?? this.segmentedControlShadow,
      segmentedDivider: segmentedDivider ?? this.segmentedDivider,
      documentContextSeparator:
          documentContextSeparator ?? this.documentContextSeparator,
      addDocumentGradientStart:
          addDocumentGradientStart ?? this.addDocumentGradientStart,
      addDocumentGradientEnd:
          addDocumentGradientEnd ?? this.addDocumentGradientEnd,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      primaryBg: Color.lerp(primaryBg, other.primaryBg, t)!,
      secondaryBg: Color.lerp(secondaryBg, other.secondaryBg, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      tertiaryText: Color.lerp(tertiaryText, other.tertiaryText, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
      menuText: Color.lerp(menuText, other.menuText, t)!,
      dangerText: Color.lerp(dangerText, other.dangerText, t)!,
      onSurfaceText: Color.lerp(onSurfaceText, other.onSurfaceText, t)!,
      documentDateText: Color.lerp(
        documentDateText,
        other.documentDateText,
        t,
      )!,
      documentTitleText: Color.lerp(
        documentTitleText,
        other.documentTitleText,
        t,
      )!,
      documentPreviewBorder: Color.lerp(
        documentPreviewBorder,
        other.documentPreviewBorder,
        t,
      )!,
      documentPreviewShadow: Color.lerp(
        documentPreviewShadow,
        other.documentPreviewShadow,
        t,
      )!,
      documentSignedBadgeFill: Color.lerp(
        documentSignedBadgeFill,
        other.documentSignedBadgeFill,
        t,
      )!,
      glassBgWhite10: Color.lerp(glassBgWhite10, other.glassBgWhite10, t)!,
      glassBgWhite20: Color.lerp(glassBgWhite20, other.glassBgWhite20, t)!,
      glassMenuFill: Color.lerp(glassMenuFill, other.glassMenuFill, t)!,
      segmentedBackfill: Color.lerp(
        segmentedBackfill,
        other.segmentedBackfill,
        t,
      )!,
      segmentedControlFill: Color.lerp(
        segmentedControlFill,
        other.segmentedControlFill,
        t,
      )!,
      segmentedControlShadow: Color.lerp(
        segmentedControlShadow,
        other.segmentedControlShadow,
        t,
      )!,
      segmentedDivider: Color.lerp(
        segmentedDivider,
        other.segmentedDivider,
        t,
      )!,
      documentContextSeparator: Color.lerp(
        documentContextSeparator,
        other.documentContextSeparator,
        t,
      )!,
      addDocumentGradientStart: Color.lerp(
        addDocumentGradientStart,
        other.addDocumentGradientStart,
        t,
      )!,
      addDocumentGradientEnd: Color.lerp(
        addDocumentGradientEnd,
        other.addDocumentGradientEnd,
        t,
      )!,
    );
  }
}

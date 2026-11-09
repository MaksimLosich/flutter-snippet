import 'package:flutter/material.dart';
import 'package:test_task/l10n/l10n_extension.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/home/widgets/app_glass_button.dart';
import 'package:test_task/presentation/home/widgets/document_grid.dart';
import 'package:test_task/presentation/home/widgets/segmented_control.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.state,
    required this.cubit,
    required this.onFilesPressed,
    required this.onPhotosPressed,
    required this.onScannerPressed,
  });

  final HomeState state;
  final HomeCubit cubit;
  final VoidCallback onFilesPressed;
  final VoidCallback onPhotosPressed;
  final VoidCallback onScannerPressed;

  @override
  Widget build(BuildContext context) {
    final documents = state.visibleDocuments;
    final Widget content;
    if (documents.isEmpty && state.documents.isEmpty && !state.hasActiveSearch) {
      content = _EmptyDocuments(
        onFilesPressed: onFilesPressed,
        onPhotosPressed: onPhotosPressed,
        onScannerPressed: onScannerPressed,
      );
    } else if (documents.isEmpty) {
      content = Center(
        child: Text(
          context.localization.homeNoMatchingDocuments,
          style: context.textTheme.bodyLarge?.copyWith(color: context.appColors.tertiaryText),
        ),
      );
    } else {
      content = DocumentGrid(
        documents: documents,
        isSelectMode: state.isSelectMode,
        selectedDocumentIds: state.selectedDocumentIds,
        documentContextMenuId: state.documentContextMenuId,
        onDocumentPressed: state.isSelectMode ? cubit.toggleDocumentSelection : cubit.toggleDocumentSignature,
        onDocumentLongPressed: cubit.showDocumentContextMenu,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius36),
          topRight: Radius.circular(AppDimens.radius36),
        ),
        color: context.appColors.secondaryBg,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.padding16),
            child: SegmentedControl(groupValue: state.documentFilter, onValueChanged: cubit.updateDocumentFilter),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  const _EmptyDocuments({required this.onFilesPressed, required this.onPhotosPressed, required this.onScannerPressed});

  final VoidCallback onFilesPressed;
  final VoidCallback onPhotosPressed;
  final VoidCallback onScannerPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.padding16,
        right: AppDimens.padding16,
        bottom:
            MediaQuery.paddingOf(context).bottom + AppDimens.floatingToolbarPadding + AppDimens.floatingToolbarHeight,
      ),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Image.asset(HomeAssets.emptyState),
            const SizedBox(height: AppDimens.padding18),
            Text(
              context.localization.homeEmptyTitle,
              style: context.textTheme.displaySmall?.copyWith(color: context.appColors.onSurfaceText),
            ),
            const SizedBox(height: AppDimens.padding10),
            Text(
              context.localization.homeEmptySubtitle,
              style: context.textTheme.bodyLarge?.copyWith(color: context.appColors.tertiaryText),
            ),
            const SizedBox(height: AppDimens.padding16),
            Row(
              mainAxisSize: .min,
              children: [
                AppGlassButton.withPadding(
                  assetUrl: HomeAssets.files,
                  title: context.localization.homeSourcesFiles,
                  onPressed: onFilesPressed,
                ),
                const SizedBox(width: AppDimens.padding12),
                AppGlassButton.withPadding(
                  assetUrl: HomeAssets.photos,
                  title: context.localization.homeSourcesPhotos,
                  onPressed: onPhotosPressed,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.padding12),
            AppGlassButton.withPadding(
              assetUrl: HomeAssets.scanner,
              title: context.localization.homeSourcesScanner,
              onPressed: onScannerPressed,
            ),
          ],
        ),
      ),
    );
  }
}

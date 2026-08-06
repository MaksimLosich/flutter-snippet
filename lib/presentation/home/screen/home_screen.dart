import 'dart:io';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/di/injector.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/presentation/home/assets.dart';
import 'package:test_task/presentation/home/widgets/add_document_button.dart';
import 'package:test_task/presentation/home/widgets/app_glass_button.dart';
import 'package:test_task/presentation/home/widgets/app_icon_button.dart';
import 'package:test_task/presentation/home/widgets/more_button.dart';
import 'package:test_task/presentation/home/widgets/segmented_control.dart';
import 'package:test_task/presentation/utils/dimens.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/logo.dart';

typedef _DocumentLongPressCallback =
    void Function(int documentId, Offset globalPosition);

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: context.appColors.primaryBg,
      statusBarStyle: GlassStatusBarStyle.auto,
      body: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocProvider<HomeCubit>(
            create: (_) => getIt<HomeCubit>(),
            child: BlocConsumer<HomeCubit, HomeState>(
              listenWhen: (previous, current) {
                return previous.errorMessage != current.errorMessage &&
                    current.errorMessage != null;
              },
              listener: (context, state) {
                final error = state.errorMessage;
                if (error != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              builder: (context, state) {
                final cubit = context.read<HomeCubit>();
                final contextMenuDocument = state.documentContextMenuDocument;

                return Column(
                  children: [
                    _Header(
                      isSelectMode: state.isSelectMode,
                      areAllDocumentsSelected:
                          state.areAllVisibleDocumentsSelected,
                      selectedDocumentCount: state.selectedDocumentCount,
                      onToggleAllSelection:
                          cubit.toggleAllVisibleDocumentsSelection,
                      onExitSelectMode: cubit.exitSelectMode,
                      onSelectPressed: cubit.enterSelectMode,
                      onAddDocumentPressed: cubit.showAddDocumentOverlay,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _Body(
                              documents: state.visibleDocuments,
                              isSearchActive: state.hasActiveSearch,
                              isSelectMode: state.isSelectMode,
                              selectedDocumentIds: state.selectedDocumentIds,
                              documentContextMenuId:
                                  state.documentContextMenuId,
                              onFilesPressed: cubit.importFromFiles,
                              onPhotosPressed: cubit.importFromPhotos,
                              onScannerPressed: cubit.scanDocument,
                              onDocumentPressed: state.isSelectMode
                                  ? cubit.toggleDocumentSelection
                                  : cubit.toggleDocumentSignature,
                              onDocumentLongPressed:
                                  cubit.showDocumentContextMenu,
                            ),
                          ),
                          if (state.isAddDocumentOverlayVisible)
                            Positioned.fill(
                              child: _AddDocumentOverlay(
                                onClose: cubit.hideAddDocumentOverlay,
                                onFilesPressed: cubit.importFromFiles,
                                onPhotosPressed: cubit.importFromPhotos,
                                onScannerPressed: cubit.scanDocument,
                              ),
                            )
                          else if (contextMenuDocument != null)
                            Positioned.fill(
                              child: _DocumentActionsOverlay(
                                document: contextMenuDocument,
                                anchor: state.documentContextMenuAnchor,
                                onDismiss: cubit.hideDocumentContextMenu,
                                onPrintPressed: cubit.printContextDocument,
                                onSharePressed: cubit.shareContextDocument,
                                onDeletePressed: cubit.deleteContextDocument,
                              ),
                            )
                          else
                            Align(
                              alignment: .bottomCenter,
                              child: state.isSelectMode
                                  ? _SelectionToolbar(
                                      onDeletePressed:
                                          cubit.deleteSelectedDocuments,
                                      onSharePressed:
                                          cubit.shareSelectedDocuments,
                                    )
                                  : _SearchMorphToolbar(
                                      isSearchVisible: state.isSearchVisible,
                                      onSearchPressed: cubit.showSearch,
                                      onAddDocumentPressed:
                                          cubit.showAddDocumentOverlay,
                                      onChanged: cubit.updateSearchQuery,
                                      onClose: cubit.hideSearch,
                                    ),
                            ),
                          if (state.isLoading)
                            const Positioned.fill(
                              child: AbsorbPointer(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
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
      padding: EdgeInsets.only(
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
                Logo(),
                const Spacer(),
                MoreButton(
                  onSelectPressed: onSelectPressed,
                  onAddDocumentPressed: onAddDocumentPressed,
                ),
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
        ? 'home.selection.deselectAll'.tr(
            namedArgs: {'count': selectedDocumentCount.toString()},
          )
        : 'home.selection.selectAll'.tr();

    return GlassButton.custom(
      onTap: onPressed,
      useOwnLayer: true,
      shape: const LiquidRoundedRectangle(borderRadius: AppDimens.radiusFull),
      settings: _buildSelectionHeaderGlassSettings(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding12,
          vertical: AppDimens.padding10,
        ),
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

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      onTap: onPressed,
      width: AppDimens.moreButtonSize,
      height: AppDimens.moreButtonSize,
      alignment: Alignment.center,
      useOwnLayer: true,
      shape: const LiquidRoundedRectangle(
        borderRadius: AppDimens.moreButtonRadius,
      ),
      settings: _buildSelectionHeaderGlassSettings(context),
      child: SvgPicture.asset(
        HomeAssets.close,
        width: AppDimens.selectionCloseIconSize,
        height: AppDimens.selectionCloseIconSize,
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

class _Body extends StatelessWidget {
  const _Body({
    required this.documents,
    required this.isSearchActive,
    required this.isSelectMode,
    required this.selectedDocumentIds,
    required this.documentContextMenuId,
    required this.onFilesPressed,
    required this.onPhotosPressed,
    required this.onScannerPressed,
    required this.onDocumentPressed,
    required this.onDocumentLongPressed,
  });

  final List<AppDocument> documents;
  final bool isSearchActive;
  final bool isSelectMode;
  final Set<int> selectedDocumentIds;
  final int? documentContextMenuId;
  final VoidCallback onFilesPressed;
  final VoidCallback onPhotosPressed;
  final VoidCallback onScannerPressed;
  final ValueChanged<int> onDocumentPressed;
  final _DocumentLongPressCallback onDocumentLongPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius36),
          topRight: Radius.circular(AppDimens.radius36),
        ),
        color: context.appColors.secondaryBg,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppDimens.padding16),
            child: SegmentedControl(),
          ),
          Expanded(
            child: documents.isEmpty && !isSearchActive
                ? _EmptyDocuments(
                    onFilesPressed: onFilesPressed,
                    onPhotosPressed: onPhotosPressed,
                    onScannerPressed: onScannerPressed,
                  )
                : _DocumentGrid(
                    documents: documents,
                    isSelectMode: isSelectMode,
                    selectedDocumentIds: selectedDocumentIds,
                    documentContextMenuId: documentContextMenuId,
                    onDocumentPressed: onDocumentPressed,
                    onDocumentLongPressed: onDocumentLongPressed,
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  const _EmptyDocuments({
    required this.onFilesPressed,
    required this.onPhotosPressed,
    required this.onScannerPressed,
  });

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
            MediaQuery.paddingOf(context).bottom +
            AppDimens.floatingToolbarPadding +
            AppDimens.floatingToolbarHeight,
      ),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Image.asset(HomeAssets.emptyState),
            const SizedBox(height: AppDimens.padding18),
            Text(
              'home.empty.title'.tr(),
              style: context.textTheme.displaySmall?.copyWith(
                color: context.appColors.onSurfaceText,
              ),
            ),
            const SizedBox(height: AppDimens.padding10),
            Text(
              'home.empty.subtitle'.tr(),
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.appColors.tertiaryText,
              ),
            ),
            const SizedBox(height: AppDimens.padding16),
            Row(
              mainAxisSize: .min,
              children: [
                AppGlassButton.withPadding(
                  assetUrl: HomeAssets.files,
                  title: 'home.sources.files'.tr(),
                  onPressed: onFilesPressed,
                ),
                const SizedBox(width: AppDimens.padding12),
                AppGlassButton.withPadding(
                  assetUrl: HomeAssets.photos,
                  title: 'home.sources.photos'.tr(),
                  onPressed: onPhotosPressed,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.padding12),
            AppGlassButton.withPadding(
              assetUrl: HomeAssets.scanner,
              title: 'home.sources.scanner'.tr(),
              onPressed: onScannerPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentGrid extends StatelessWidget {
  const _DocumentGrid({
    required this.documents,
    required this.isSelectMode,
    required this.selectedDocumentIds,
    required this.documentContextMenuId,
    required this.onDocumentPressed,
    required this.onDocumentLongPressed,
  });

  static const _minColumns = 1;

  final List<AppDocument> documents;
  final bool isSelectMode;
  final Set<int> selectedDocumentIds;
  final int? documentContextMenuId;
  final ValueChanged<int> onDocumentPressed;
  final _DocumentLongPressCallback onDocumentLongPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - AppDimens.padding16 * 2;
        final columns = math.max(
          _minColumns,
          (availableWidth / AppDimens.documentCardDesignWidth).floor(),
        );
        final itemWidth =
            (availableWidth - AppDimens.padding12 * (columns - 1)) / columns;

        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppDimens.padding16,
            right: AppDimens.padding16,
            bottom:
                MediaQuery.paddingOf(context).bottom +
                AppDimens.floatingToolbarPadding +
                AppDimens.floatingToolbarHeight,
          ),
          child: Wrap(
            spacing: AppDimens.padding12,
            runSpacing: AppDimens.padding16,
            children: [
              for (final document in documents)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity:
                      documentContextMenuId != null &&
                          documentContextMenuId != document.id
                      ? AppDimens.documentContextInactiveOpacity
                      : 1,
                  child: SizedBox(
                    width: itemWidth,
                    child: AspectRatio(
                      aspectRatio: AppDimens.documentCardAspectRatio,
                      child: _DocumentCard(
                        document: document,
                        isSelectMode: isSelectMode,
                        isSelected: selectedDocumentIds.contains(document.id),
                        onPressed: () => onDocumentPressed(document.id),
                        onLongPressStart: (globalPosition) {
                          onDocumentLongPressed(document.id, globalPosition);
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.isSelectMode,
    required this.isSelected,
    required this.onPressed,
    required this.onLongPressStart,
  });

  static const _titleMaxLines = 1;
  static const _dateMaxLines = 1;
  static const _titleFontSize = 14.0;
  static const _dateFontSize = 11.0;
  static const _textHeight = 1.2;
  static const _letterSpacing = 0.0;
  static const _previewTitleGap = AppDimens.padding12;

  final AppDocument document;
  final bool isSelectMode;
  final bool isSelected;
  final VoidCallback onPressed;
  final ValueChanged<Offset> onLongPressStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      onLongPressStart: isSelectMode
          ? null
          : (details) => onLongPressStart(details.globalPosition),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _DocumentPreview(
            document: document,
            isSelectMode: isSelectMode,
            isSelected: isSelected,
          ),
          const SizedBox(height: _previewTitleGap),
          Text(
            document.title,
            maxLines: _titleMaxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.appColors.documentTitleText,
              fontSize: _titleFontSize,
              height: _textHeight,
              letterSpacing: _letterSpacing,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.padding4),
          Text(
            _formatDate(document.createdAt),
            maxLines: _dateMaxLines,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.appColors.documentDateText,
              fontSize: _dateFontSize,
              height: _textHeight,
              letterSpacing: _letterSpacing,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}

class _DocumentPreview extends StatelessWidget {
  const _DocumentPreview({
    required this.document,
    required this.isSelectMode,
    required this.isSelected,
  });

  static const _pageWidthRatio =
      AppDimens.documentPreviewDesignWidth / AppDimens.documentCardDesignWidth;
  static const _secondPageOffsetRatio =
      AppDimens.documentPreviewSecondPageOffset /
      AppDimens.documentCardDesignWidth;
  static const _secondPageAngle = 7.35 * math.pi / 180;
  static const _secondPageShadowOffset = Offset(0, 4);
  static const _secondPageShadowBlurRadius = 11.1;
  static const _signedBadgeSize = 42.0;
  static const _signedBadgeYOffset = AppDimens.padding8;

  final AppDocument document;
  final bool isSelectMode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final pageWidth = cardWidth * _pageWidthRatio;
        final pageHeight = pageWidth / AppDimens.documentPreviewAspectRatio;
        final secondPageOffset = cardWidth * _secondPageOffsetRatio;
        final lastPreviewPath = document.lastPreviewPath;

        if (lastPreviewPath == null) {
          return SizedBox(
            width: pageWidth,
            height: pageHeight,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: _DocumentPreviewPage(path: document.firstPreviewPath),
                ),
                if (document.isSigned)
                  Transform.translate(
                    offset: const Offset(0, _signedBadgeYOffset),
                    child: const _SignedBadge(),
                  ),
                if (isSelectMode)
                  Align(
                    alignment: Alignment.center,
                    child: _SelectionIndicator(isSelected: isSelected),
                  ),
              ],
            ),
          );
        }

        return SizedBox(
          width: pageWidth + secondPageOffset,
          height: pageHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                top: 0,
                width: pageWidth,
                height: pageHeight,
                child: _DocumentPreviewPage(path: document.firstPreviewPath),
              ),
              Positioned(
                left: secondPageOffset,
                top: 0,
                width: pageWidth,
                height: pageHeight,
                child: Transform.rotate(
                  angle: _secondPageAngle,
                  child: _DocumentPreviewPage(
                    path: lastPreviewPath,
                    boxShadow: [
                      BoxShadow(
                        offset: _secondPageShadowOffset,
                        blurRadius: _secondPageShadowBlurRadius,
                        color: context.appColors.documentPreviewShadow,
                      ),
                    ],
                  ),
                ),
              ),
              if (document.isSigned)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: const Offset(0, _signedBadgeYOffset),
                    child: const _SignedBadge(),
                  ),
                ),
              if (isSelectMode)
                Align(
                  alignment: Alignment.center,
                  child: _SelectionIndicator(isSelected: isSelected),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isSelected ? HomeAssets.selected : HomeAssets.unselected,
      width: AppDimens.selectionIndicatorSize,
      height: AppDimens.selectionIndicatorSize,
    );
  }
}

class _SignedBadge extends StatelessWidget {
  const _SignedBadge();

  @override
  Widget build(BuildContext context) {
    final settings = LiquidGlassSettings.figma(
      glassColor: context.appColors.documentSignedBadgeFill,
      lightAngle: -math.pi / 4,
      lightIntensity: 80,
      refraction: 0,
      depth: 20,
      dispersion: 50,
      frost: 25,
    );

    return GlassContainer(
      width: _DocumentPreview._signedBadgeSize,
      height: _DocumentPreview._signedBadgeSize,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      settings: settings,
      useOwnLayer: true,
      shape: const LiquidOval(),
      child: SvgPicture.asset(HomeAssets.sign),
    );
  }
}

class _DocumentPreviewPage extends StatelessWidget {
  const _DocumentPreviewPage({required this.path, this.boxShadow = const []});

  final String path;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.secondaryBg,
        borderRadius: BorderRadius.circular(AppDimens.padding12),
        border: Border.all(color: context.appColors.documentPreviewBorder),
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.padding12),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: context.appColors.secondaryBg,
              child: Center(
                child: Icon(
                  Icons.picture_as_pdf,
                  color: context.appColors.documentDateText,
                  size: AppDimens.size32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AddDocumentOverlay extends StatelessWidget {
  const _AddDocumentOverlay({
    required this.onClose,
    required this.onFilesPressed,
    required this.onPhotosPressed,
    required this.onScannerPressed,
  });

  final VoidCallback onClose;
  final VoidCallback onFilesPressed;
  final VoidCallback onPhotosPressed;
  final VoidCallback onScannerPressed;

  @override
  Widget build(BuildContext context) {
    const rightPadding = 16.1;

    final settings = LiquidGlassSettings.figma(
      glassColor: const Color(0x00FFFFFF),
      lightAngle: -math.pi / 4,
      lightIntensity: 0,
      refraction: 2,
      depth: 62,
      dispersion: 49,
      frost: 10,
    );

    return GlassContainer(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      settings: settings,
      useOwnLayer: true,
      shape: const LiquidVerticalRoundedRectangle(
        topRadius: AppDimens.radius36,
        bottomRadius: 0,
      ),
      child: Align(
        alignment: .bottomRight,
        child: Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.paddingOf(context).bottom +
                AppDimens.floatingToolbarPadding,
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: AppDimens.padding28),
                child: Column(
                  mainAxisSize: .min,
                  spacing: AppDimens.padding12,
                  children: [
                    AppGlassButton.tight(
                      assetUrl: HomeAssets.files,
                      title: 'home.sources.files'.tr(),
                      onPressed: onFilesPressed,
                    ),
                    AppGlassButton.tight(
                      assetUrl: HomeAssets.photos,
                      title: 'home.sources.photos'.tr(),
                      onPressed: onPhotosPressed,
                    ),
                    AppGlassButton.tight(
                      assetUrl: HomeAssets.scanner,
                      title: 'home.sources.scanner'.tr(),
                      onPressed: onScannerPressed,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.padding12),
              Padding(
                padding: const EdgeInsets.only(right: rightPadding),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      'home.actions.addDocumentFrom'.tr(),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: .w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(width: AppDimens.padding16),
                    AppIconButton(
                      onPressed: onClose,
                      assetUrl: HomeAssets.close,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentActionsOverlay extends StatelessWidget {
  const _DocumentActionsOverlay({
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
  final VoidCallback onSharePressed;
  final VoidCallback onDeletePressed;

  static const _anchorGap = AppDimens.padding12;
  static const _estimatedMenuHeight = 180.0;
  static const _edgePadding = AppDimens.padding12;

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
            final localAnchor = anchor == null || overlayBox == null
                ? Offset(constraints.maxWidth / 2, constraints.maxHeight / 2)
                : overlayBox.globalToLocal(anchor!);
            final width = math.min(
              constraints.maxWidth - _edgePadding * 2,
              AppDimens.documentContextMenuMaxWidth,
            );
            final bottomLimit =
                constraints.maxHeight -
                MediaQuery.paddingOf(context).bottom -
                _edgePadding;
            final preferredTop = localAnchor.dy + _anchorGap;
            final fallbackTop =
                localAnchor.dy - _estimatedMenuHeight - _anchorGap;
            final menuTop = preferredTop + _estimatedMenuHeight <= bottomLimit
                ? preferredTop
                : fallbackTop;
            final left = (localAnchor.dx - width / 2)
                .clamp(
                  _edgePadding,
                  constraints.maxWidth - width - _edgePadding,
                )
                .toDouble();
            final top = menuTop
                .clamp(
                  _edgePadding,
                  math.max(_edgePadding, bottomLimit - _estimatedMenuHeight),
                )
                .toDouble();

            return Stack(
              children: [
                Positioned(
                  left: left,
                  top: top,
                  child: GestureDetector(
                    onTap: () {},
                    child: GlassContainer(
                      width: width,
                      clipBehavior: Clip.antiAlias,
                      settings: _buildDocumentContextMenuSettings(context),
                      useOwnLayer: true,
                      shape: const LiquidRoundedRectangle(
                        borderRadius: AppDimens.radius34,
                      ),
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
                                    title: 'home.documentActions.print'.tr(),
                                    onTap: onPrintPressed,
                                  ),
                                ),
                                const SizedBox(width: AppDimens.padding24),
                                Expanded(
                                  child: _DocumentContextPrimaryAction(
                                    assetUrl: HomeAssets.share2,
                                    title: 'home.documentActions.share'.tr(),
                                    onTap: onSharePressed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.padding32,
                            ),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: context.appColors.documentContextSeparator,
                            ),
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
  const _DocumentContextPrimaryAction({
    required this.assetUrl,
    required this.title,
    required this.onTap,
  });

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
            width: AppDimens.documentContextMenuIconSize,
            height: AppDimens.documentContextMenuIconSize,
            colorFilter: ColorFilter.mode(
              context.appColors.menuText,
              BlendMode.srcIn,
            ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding32,
          vertical: AppDimens.padding24,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              HomeAssets.delete2,
              width: AppDimens.documentContextMenuIconSize,
              height: AppDimens.documentContextMenuIconSize,
              colorFilter: ColorFilter.mode(
                context.appColors.dangerText,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppDimens.padding16),
            Text(
              'home.documentActions.delete'.tr(),
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

class _SearchMorphToolbar extends StatelessWidget {
  const _SearchMorphToolbar({
    required this.isSearchVisible,
    required this.onSearchPressed,
    required this.onAddDocumentPressed,
    required this.onChanged,
    required this.onClose,
  });

  static const _duration = Duration(milliseconds: 360);
  static const _spacing = AppDimens.padding12;
  static const _addButtonSlideDistance = 28.0;
  static const _closeButtonSlideDistance = 10.0;
  static const _searchIconFadeStart = 0.12;
  static const _searchIconFadeEnd = 0.52;
  static const _searchIconMoveEnd = 0.36;
  static const _fieldOpacityStart = 0.48;
  static const _closeOpacityStart = 0.62;
  static const _closeStartScale = 0.92;
  static const _fieldPointerStart = 0.86;
  static const _searchIconSize = AppDimens.searchFieldIconSize;
  static const _searchIconLeftPadding = AppDimens.padding16;

  final bool isSearchVisible;
  final VoidCallback onSearchPressed;
  final VoidCallback onAddDocumentPressed;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final settings = LiquidGlassSettings.figma(
      glassColor: context.appColors.glassBgWhite20,
      lightAngle: -math.pi / 4,
      lightIntensity: 80,
      refraction: 29,
      depth: 17,
      dispersion: 50,
      frost: 10,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.padding12,
        right: AppDimens.padding12,
        bottom:
            MediaQuery.paddingOf(context).bottom +
            AppDimens.floatingToolbarPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final expandedSearchWidth = math.max(
            AppDimens.searchButtonSize,
            constraints.maxWidth - _spacing - AppDimens.size48,
          );

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: isSearchVisible ? 1 : 0),
            duration: _duration,
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              final progress = value;
              final searchWidth = _lerp(
                AppDimens.searchButtonSize,
                expandedSearchWidth,
                progress,
              );
              final searchHeight = _lerp(
                AppDimens.searchButtonSize,
                AppDimens.searchFieldHeight,
                progress,
              );
              final searchTop = (AppDimens.searchButtonSize - searchHeight) / 2;
              final fieldOpacity = Curves.easeInOut.transform(
                _interval(progress, _fieldOpacityStart, 1),
              );
              final searchIconOpacity =
                  1 -
                  Curves.easeInOut.transform(
                    _interval(
                      progress,
                      _searchIconFadeStart,
                      _searchIconFadeEnd,
                    ),
                  );
              final searchIconLeft = _lerp(
                (AppDimens.searchButtonSize - _searchIconSize) / 2,
                _searchIconLeftPadding,
                Curves.easeInOut.transform(
                  _interval(progress, 0, _searchIconMoveEnd),
                ),
              );
              final closeOpacity = Curves.easeInOut.transform(
                _interval(progress, _closeOpacityStart, 1),
              );
              final addOpacity =
                  1 -
                  Curves.easeInOut.transform(_interval(progress, 0.08, 0.78));

              return SizedBox(
                height: AppDimens.searchButtonSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
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
                                  shape: const LiquidRoundedRectangle(
                                    borderRadius: AppDimens.radiusFull,
                                  ),
                                  settings: settings,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: searchIconLeft,
                                        top:
                                            (searchHeight - _searchIconSize) /
                                            2,
                                        child: Opacity(
                                          opacity: searchIconOpacity,
                                          child: SvgPicture.asset(
                                            HomeAssets.search,
                                            width: _searchIconSize,
                                            height: _searchIconSize,
                                          ),
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
                                  ignoring:
                                      !isSearchVisible ||
                                      progress < _fieldPointerStart,
                                  child: Opacity(
                                    opacity: fieldOpacity,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: _SearchField(
                                        onChanged: onChanged,
                                        settings: settings,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IgnorePointer(
                        ignoring: isSearchVisible || progress > 0.05,
                        child: Opacity(
                          opacity: addOpacity,
                          child: Transform.translate(
                            offset: Offset(
                              progress * _addButtonSlideDistance,
                              0,
                            ),
                            child: AddDocumentButton(
                              onPressed: onAddDocumentPressed,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: (AppDimens.searchButtonSize - AppDimens.size48) / 2,
                      child: IgnorePointer(
                        ignoring: !isSearchVisible,
                        child: Opacity(
                          opacity: closeOpacity,
                          child: Transform.translate(
                            offset: Offset(
                              (1 - progress) * _closeButtonSlideDistance,
                              0,
                            ),
                            child: Transform.scale(
                              scale: _lerp(_closeStartScale, 1, progress),
                              child: AppIconButton(
                                assetUrl: HomeAssets.close,
                                size: AppDimens.size48,
                                onPressed: onClose,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  double _lerp(double start, double end, double progress) {
    return start + (end - start) * progress;
  }

  double _interval(double value, double start, double end) {
    return ((value - start) / (end - start)).clamp(0.0, 1.0);
  }
}

class _SelectionToolbar extends StatelessWidget {
  const _SelectionToolbar({
    required this.onDeletePressed,
    required this.onSharePressed,
  });

  final VoidCallback onDeletePressed;
  final VoidCallback onSharePressed;

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
          AppIconButton(
            assetUrl: HomeAssets.delete,
            size: AppDimens.size62,
            onPressed: onDeletePressed,
          ),
          const Spacer(),
          AppIconButton(
            assetUrl: HomeAssets.share,
            size: AppDimens.size62,
            onPressed: onSharePressed,
          ),
        ],
      ),
    );
  }
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
      height: AppDimens.searchFieldHeight,
      autofocus: true,
      placeholder: 'home.actions.search'.tr(),
      prefixIcon: Icon(
        CupertinoIcons.search,
        size: AppDimens.searchFieldIconSize,
        color: context.appColors.buttonText,
      ),
      suffixIcon: _hasText
          ? Icon(
              CupertinoIcons.clear_circled_solid,
              size: AppDimens.searchFieldClearIconSize,
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

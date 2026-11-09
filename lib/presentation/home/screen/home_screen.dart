import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:test_task/core/error/failure.dart';
import 'package:test_task/di/injector.dart';
import 'package:test_task/domain/failures/document_failure.dart';
import 'package:test_task/l10n/l10n_extension.dart';
import 'package:test_task/presentation/home/widgets/add_document_overlay.dart';
import 'package:test_task/presentation/home/widgets/document_actions_overlay.dart';
import 'package:test_task/presentation/home/widgets/home_body.dart';
import 'package:test_task/presentation/home/widgets/home_header.dart';
import 'package:test_task/presentation/home/widgets/search_toolbar.dart';
import 'package:test_task/presentation/home/widgets/selection_toolbar.dart';
import 'package:test_task/presentation/utils/theme_extensions.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

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
                return previous.failure != current.failure && current.failure != null;
              },
              listener: (context, state) {
                final failure = state.failure;
                if (failure != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(_failureMessage(context, failure))));
                }
              },
              builder: (context, state) {
                final cubit = context.read<HomeCubit>();
                final contextMenuDocument = state.documentContextMenuDocument;
                final previewBackgroundColorArgb = context.appColors.documentPreviewBackground.toARGB32();
                Future<void> onFilesPressed() => cubit.importFromFiles(previewBackgroundColorArgb);
                Future<void> onPhotosPressed() => cubit.importFromPhotos(previewBackgroundColorArgb);
                Future<void> onScannerPressed() => cubit.scanDocument(previewBackgroundColorArgb);

                return Column(
                  children: [
                    AbsorbPointer(
                      absorbing: state.isLoading,
                      child: HomeHeader(
                        isSelectMode: state.isSelectMode,
                        areAllDocumentsSelected: state.areAllVisibleDocumentsSelected,
                        selectedDocumentCount: state.selectedDocumentCount,
                        onToggleAllSelection: cubit.toggleAllVisibleDocumentsSelection,
                        onExitSelectMode: cubit.exitSelectMode,
                        onSelectPressed: cubit.enterSelectMode,
                        onAddDocumentPressed: cubit.showAddDocumentOverlay,
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: HomeBody(
                              state: state,
                              cubit: cubit,
                              onFilesPressed: onFilesPressed,
                              onPhotosPressed: onPhotosPressed,
                              onScannerPressed: onScannerPressed,
                            ),
                          ),
                          if (state.isAddDocumentOverlayVisible)
                            Positioned.fill(
                              child: AddDocumentOverlay(
                                onClose: cubit.hideAddDocumentOverlay,
                                onFilesPressed: onFilesPressed,
                                onPhotosPressed: onPhotosPressed,
                                onScannerPressed: onScannerPressed,
                              ),
                            )
                          else if (contextMenuDocument != null)
                            Positioned.fill(
                              child: DocumentActionsOverlay(
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
                                  ? SelectionToolbar(
                                      onDeletePressed: cubit.deleteSelectedDocuments,
                                      onSharePressed: cubit.shareSelectedDocuments,
                                    )
                                  : SearchMorphToolbar(
                                      isSearchVisible: state.isSearchVisible,
                                      onSearchPressed: cubit.showSearch,
                                      onAddDocumentPressed: cubit.showAddDocumentOverlay,
                                      onChanged: cubit.updateSearchQuery,
                                      onClose: cubit.hideSearch,
                                    ),
                            ),
                          if (state.isLoading)
                            const Positioned.fill(
                              child: AbsorbPointer(child: Center(child: CircularProgressIndicator())),
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

  String _failureMessage(BuildContext context, Failure failure) {
    final l10n = context.localization;
    return switch (failure) {
      DocumentFailure(:final operation) => switch (operation) {
        DocumentOperation.load => l10n.homeErrorsLoad,
        DocumentOperation.import => l10n.homeErrorsImport,
        DocumentOperation.scan => l10n.homeErrorsScan,
        DocumentOperation.update => l10n.homeErrorsUpdate,
        DocumentOperation.delete => l10n.homeErrorsDelete,
        DocumentOperation.share => l10n.homeErrorsShare,
        DocumentOperation.print => l10n.homeErrorsPrint,
      },
      _ => l10n.homeErrorsUnexpected,
    };
  }
}

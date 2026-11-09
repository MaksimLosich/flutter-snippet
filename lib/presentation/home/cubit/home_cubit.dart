import 'dart:async';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task/core/error/failure.dart';
import 'package:test_task/core/error/result.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/domain/usecases/delete_documents_usecase.dart';
import 'package:test_task/domain/usecases/import_pdf_documents_usecase.dart';
import 'package:test_task/domain/usecases/import_photo_documents_usecase.dart';
import 'package:test_task/domain/usecases/print_document_usecase.dart';
import 'package:test_task/domain/usecases/scan_document_usecase.dart';
import 'package:test_task/domain/usecases/share_documents_usecase.dart';
import 'package:test_task/domain/usecases/toggle_document_signature_usecase.dart';
import 'package:test_task/domain/usecases/watch_documents_usecase.dart';

import '../models/document_filter.dart';
import 'home_state.dart';

@injectable
final class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._watchDocumentsUseCase,
    this._importPdfDocumentsUseCase,
    this._importPhotoDocumentsUseCase,
    this._scanDocumentUseCase,
    this._toggleDocumentSignatureUseCase,
    this._deleteDocumentsUseCase,
    this._shareDocumentsUseCase,
    this._printDocumentUseCase,
  ) : super(const HomeState()) {
    _watchDocuments();
  }

  final WatchDocumentsUseCase _watchDocumentsUseCase;
  final ImportPdfDocumentsUseCase _importPdfDocumentsUseCase;
  final ImportPhotoDocumentsUseCase _importPhotoDocumentsUseCase;
  final ScanDocumentUseCase _scanDocumentUseCase;
  final ToggleDocumentSignatureUseCase _toggleDocumentSignatureUseCase;
  final DeleteDocumentsUseCase _deleteDocumentsUseCase;
  final ShareDocumentsUseCase _shareDocumentsUseCase;
  final PrintDocumentUseCase _printDocumentUseCase;

  StreamSubscription<Result<List<AppDocument>>>? _documentsSubscription;

  void showAddDocumentOverlay() {
    emit(
      state.copyWith(
        isAddDocumentOverlayVisible: true,
        isSearchVisible: false,
        isSelectMode: false,
        selectedDocumentIds: const {},
        documentContextMenuId: null,
        documentContextMenuAnchor: null,
        searchQuery: '',
      ),
    );
  }

  void hideAddDocumentOverlay() {
    emit(state.copyWith(isAddDocumentOverlayVisible: false));
  }

  void showSearch() {
    emit(
      state.copyWith(
        isSearchVisible: true,
        isAddDocumentOverlayVisible: false,
        isSelectMode: false,
        selectedDocumentIds: const {},
        documentContextMenuId: null,
        documentContextMenuAnchor: null,
      ),
    );
  }

  void hideSearch() {
    emit(state.copyWith(isSearchVisible: false, searchQuery: ''));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void updateDocumentFilter(DocumentFilter filter) {
    emit(state.copyWith(documentFilter: filter, documentContextMenuId: null, documentContextMenuAnchor: null));
  }

  void enterSelectMode() {
    emit(
      state.copyWith(
        isSelectMode: true,
        selectedDocumentIds: const {},
        isSearchVisible: false,
        isAddDocumentOverlayVisible: false,
        documentContextMenuId: null,
        documentContextMenuAnchor: null,
        searchQuery: '',
      ),
    );
  }

  void exitSelectMode() {
    emit(state.copyWith(isSelectMode: false, selectedDocumentIds: const {}));
  }

  void showDocumentContextMenu(int documentId, Offset anchor) {
    if (!state.isSelectMode) {
      emit(
        state.copyWith(
          documentContextMenuId: documentId,
          documentContextMenuAnchor: anchor,
          isAddDocumentOverlayVisible: false,
          isSearchVisible: false,
          searchQuery: '',
        ),
      );
    }
  }

  void hideDocumentContextMenu() {
    emit(state.copyWith(documentContextMenuId: null, documentContextMenuAnchor: null));
  }

  void toggleDocumentSelection(int documentId) {
    final selectedIds = {...state.selectedDocumentIds};
    if (!selectedIds.add(documentId)) {
      selectedIds.remove(documentId);
    }
    emit(state.copyWith(selectedDocumentIds: selectedIds));
  }

  void toggleAllVisibleDocumentsSelection() {
    final visibleIds = state.visibleDocuments.map((document) => document.id);
    final selectedIds = {...state.selectedDocumentIds};

    if (state.areAllVisibleDocumentsSelected) {
      selectedIds.removeAll(visibleIds);
    } else {
      selectedIds.addAll(visibleIds);
    }

    emit(state.copyWith(selectedDocumentIds: selectedIds));
  }

  Future<void> importFromFiles(int previewBackgroundColorArgb) {
    return _runImport(() => _importPdfDocumentsUseCase(previewBackgroundColorArgb));
  }

  Future<void> importFromPhotos(int previewBackgroundColorArgb) {
    return _runImport(() => _importPhotoDocumentsUseCase(previewBackgroundColorArgb));
  }

  Future<void> scanDocument(int previewBackgroundColorArgb) {
    return _runImport(() => _scanDocumentUseCase(previewBackgroundColorArgb));
  }

  Future<void> toggleDocumentSignature(int documentId) async {
    await _runAction(() => _toggleDocumentSignatureUseCase(documentId));
  }

  Future<void> deleteSelectedDocuments() async {
    final isDeleted = await _runSelectionAction(() {
      return _deleteDocumentsUseCase(state.selectedDocumentIds);
    });
    if (isDeleted) {
      exitSelectMode();
    }
  }

  Future<void> shareSelectedDocuments(Rect sharePositionOrigin) {
    return _runSelectionAction(() {
      return _shareDocumentsUseCase(state.selectedDocumentIds, sharePositionOrigin);
    });
  }

  Future<void> printContextDocument() async {
    final documentId = state.documentContextMenuId;
    if (documentId != null) {
      final isPrinted = await _runAction(() {
        return _printDocumentUseCase(documentId);
      });
      if (isPrinted) {
        hideDocumentContextMenu();
      }
    }
  }

  Future<void> shareContextDocument(Rect sharePositionOrigin) async {
    final documentId = state.documentContextMenuId;
    if (documentId != null) {
      final isShared = await _runAction(() {
        return _shareDocumentsUseCase({documentId}, sharePositionOrigin);
      });
      if (isShared) {
        hideDocumentContextMenu();
      }
    }
  }

  Future<void> deleteContextDocument() async {
    final documentId = state.documentContextMenuId;
    if (documentId != null) {
      final isDeleted = await _runAction(() {
        return _deleteDocumentsUseCase({documentId});
      });
      if (isDeleted) {
        hideDocumentContextMenu();
      }
    }
  }

  void _watchDocuments() {
    _documentsSubscription = _watchDocumentsUseCase().listen(
      (result) {
        if (!isClosed) {
          result.on(
            success: (documents) {
              emit(state.copyWith(documents: documents, failure: null));
            },
            failure: _emitFailure,
          );
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!isClosed) {
          _emitFailure(UnknownFailure(error, stackTrace));
        }
      },
    );
  }

  Future<void> _runImport(Future<Result<void>> Function() import) async {
    final isImported = await _runAction(import);
    if (isImported && !isClosed) {
      emit(state.copyWith(isAddDocumentOverlayVisible: false));
    }
  }

  Future<bool> _runSelectionAction(Future<Result<void>> Function() action) async {
    if (state.selectedDocumentIds.isNotEmpty) {
      return _runAction(action);
    }
    return false;
  }

  Future<bool> _runAction(Future<Result<void>> Function() action) async {
    if (!isClosed && !state.isLoading) {
      emit(state.copyWith(isLoading: true, failure: null));

      final result = await _execute(action);
      if (!isClosed) {
        return result.on(
          success: (_) {
            emit(state.copyWith(isLoading: false));
            return true;
          },
          failure: (failure) {
            emit(state.copyWith(isLoading: false, failure: failure));
            return false;
          },
        );
      }
    }
    return false;
  }

  Future<Result<void>> _execute(Future<Result<void>> Function() action) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      return Err(UnknownFailure(error, stackTrace));
    }
  }

  void _emitFailure(Failure failure) {
    emit(state.copyWith(failure: failure));
  }

  @override
  Future<void> close() async {
    await _documentsSubscription?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/domain/usecases/delete_documents_usecase.dart';
import 'package:test_task/domain/usecases/import_pdf_documents_usecase.dart';
import 'package:test_task/domain/usecases/import_photo_documents_usecase.dart';
import 'package:test_task/domain/usecases/print_document_usecase.dart';
import 'package:test_task/domain/usecases/scan_document_usecase.dart';
import 'package:test_task/domain/usecases/share_documents_usecase.dart';
import 'package:test_task/domain/usecases/toggle_document_signature_usecase.dart';
import 'package:test_task/domain/usecases/watch_documents_usecase.dart';

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

  StreamSubscription<List<AppDocument>>? _documentsSubscription;

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
    if (state.isSelectMode) {
      return;
    }

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

  void hideDocumentContextMenu() {
    emit(
      state.copyWith(
        documentContextMenuId: null,
        documentContextMenuAnchor: null,
      ),
    );
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

  Future<void> importFromFiles() {
    return _runImport(() => _importPdfDocumentsUseCase());
  }

  Future<void> importFromPhotos() {
    return _runImport(() => _importPhotoDocumentsUseCase());
  }

  Future<void> scanDocument() {
    return _runImport(() => _scanDocumentUseCase());
  }

  Future<void> toggleDocumentSignature(int documentId) async {
    try {
      await _toggleDocumentSignatureUseCase(documentId);
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> deleteSelectedDocuments() async {
    final isDeleted = await _runSelectionAction(() {
      return _deleteDocumentsUseCase(state.selectedDocumentIds);
    });
    if (isDeleted) {
      exitSelectMode();
    }
  }

  Future<void> shareSelectedDocuments() {
    return _runSelectionAction(() {
      return _shareDocumentsUseCase(state.selectedDocumentIds);
    });
  }

  Future<void> printContextDocument() async {
    final documentId = state.documentContextMenuId;
    if (documentId == null) {
      return;
    }

    final isPrinted = await _runContextAction(() {
      return _printDocumentUseCase(documentId);
    });
    if (isPrinted) {
      hideDocumentContextMenu();
    }
  }

  Future<void> shareContextDocument() async {
    final documentId = state.documentContextMenuId;
    if (documentId == null) {
      return;
    }

    final isShared = await _runContextAction(() {
      return _shareDocumentsUseCase({documentId});
    });
    if (isShared) {
      hideDocumentContextMenu();
    }
  }

  Future<void> deleteContextDocument() async {
    final documentId = state.documentContextMenuId;
    if (documentId == null) {
      return;
    }

    final isDeleted = await _runContextAction(() {
      return _deleteDocumentsUseCase({documentId});
    });
    if (isDeleted) {
      hideDocumentContextMenu();
    }
  }

  void _watchDocuments() {
    _documentsSubscription = _watchDocumentsUseCase().listen(
      (documents) {
        emit(state.copyWith(documents: documents, errorMessage: null));
      },
      onError: (Object error) {
        emit(state.copyWith(errorMessage: error.toString()));
      },
    );
  }

  Future<void> _runImport(Future<void> Function() import) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await import();
      emit(
        state.copyWith(isLoading: false, isAddDocumentOverlayVisible: false),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<bool> _runSelectionAction(Future<void> Function() action) async {
    if (state.selectedDocumentIds.isEmpty) {
      return false;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await action();
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      return false;
    }
  }

  Future<bool> _runContextAction(Future<void> Function() action) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await action();
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _documentsSubscription?.cancel();
    return super.close();
  }
}

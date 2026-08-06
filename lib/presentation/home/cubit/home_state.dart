import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:test_task/domain/entities/app_document.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.documents = const [],
    this.isLoading = false,
    this.isAddDocumentOverlayVisible = false,
    this.isSearchVisible = false,
    this.isSelectMode = false,
    this.selectedDocumentIds = const {},
    this.documentContextMenuId,
    this.documentContextMenuAnchor,
    this.searchQuery = '',
    this.errorMessage,
  });

  static const _notSet = Object();

  final List<AppDocument> documents;
  final bool isLoading;
  final bool isAddDocumentOverlayVisible;
  final bool isSearchVisible;
  final bool isSelectMode;
  final Set<int> selectedDocumentIds;
  final int? documentContextMenuId;
  final Offset? documentContextMenuAnchor;
  final String searchQuery;
  final String? errorMessage;

  bool get hasActiveSearch => searchQuery.trim().isNotEmpty;

  int get selectedDocumentCount => selectedDocumentIds.length;

  AppDocument? get documentContextMenuDocument {
    final id = documentContextMenuId;
    if (id == null) {
      return null;
    }

    for (final document in visibleDocuments) {
      if (document.id == id) {
        return document;
      }
    }

    return null;
  }

  List<AppDocument> get visibleDocuments {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return documents;
    }

    return documents.where((document) {
      return document.title.toLowerCase().contains(query);
    }).toList();
  }

  bool get areAllVisibleDocumentsSelected {
    if (visibleDocuments.isEmpty) {
      return false;
    }

    return visibleDocuments.every((document) {
      return selectedDocumentIds.contains(document.id);
    });
  }

  HomeState copyWith({
    List<AppDocument>? documents,
    bool? isLoading,
    bool? isAddDocumentOverlayVisible,
    bool? isSearchVisible,
    bool? isSelectMode,
    Set<int>? selectedDocumentIds,
    Object? documentContextMenuId = _notSet,
    Object? documentContextMenuAnchor = _notSet,
    String? searchQuery,
    Object? errorMessage = _notSet,
  }) {
    return HomeState(
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
      isAddDocumentOverlayVisible:
          isAddDocumentOverlayVisible ?? this.isAddDocumentOverlayVisible,
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
      isSelectMode: isSelectMode ?? this.isSelectMode,
      selectedDocumentIds: selectedDocumentIds ?? this.selectedDocumentIds,
      documentContextMenuId: identical(documentContextMenuId, _notSet)
          ? this.documentContextMenuId
          : documentContextMenuId as int?,
      documentContextMenuAnchor: identical(documentContextMenuAnchor, _notSet)
          ? this.documentContextMenuAnchor
          : documentContextMenuAnchor as Offset?,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: identical(errorMessage, _notSet)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props {
    return [
      documents,
      isLoading,
      isAddDocumentOverlayVisible,
      isSearchVisible,
      isSelectMode,
      selectedDocumentIds.toList()..sort(),
      documentContextMenuId,
      documentContextMenuAnchor,
      searchQuery,
      errorMessage,
    ];
  }
}

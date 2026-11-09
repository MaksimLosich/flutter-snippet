import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:test_task/core/error/failure.dart';
import 'package:test_task/domain/entities/app_document.dart';

import '../models/document_filter.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.documents = const [],
    this.documentFilter = DocumentFilter.all,
    this.isLoading = false,
    this.isAddDocumentOverlayVisible = false,
    this.isSearchVisible = false,
    this.isSelectMode = false,
    this.selectedDocumentIds = const {},
    this.documentContextMenuId,
    this.documentContextMenuAnchor,
    this.searchQuery = '',
    this.failure,
  });

  static const _notSet = Object();

  final List<AppDocument> documents;
  final DocumentFilter documentFilter;
  final bool isLoading;
  final bool isAddDocumentOverlayVisible;
  final bool isSearchVisible;
  final bool isSelectMode;
  final Set<int> selectedDocumentIds;
  final int? documentContextMenuId;
  final Offset? documentContextMenuAnchor;
  final String searchQuery;
  final Failure? failure;

  bool get hasActiveSearch => searchQuery.trim().isNotEmpty;

  int get selectedDocumentCount => selectedDocumentIds.length;

  AppDocument? get documentContextMenuDocument {
    return visibleDocuments.where((document) => document.id == documentContextMenuId).firstOrNull;
  }

  List<AppDocument> get visibleDocuments {
    final query = searchQuery.trim().toLowerCase();
    return documents.where((document) {
      final matchesFilter = switch (documentFilter) {
        DocumentFilter.all => true,
        DocumentFilter.signed => document.isSigned,
        DocumentFilter.unsigned => !document.isSigned,
      };
      final matchesSearch = query.isEmpty || document.title.toLowerCase().contains(query);
      return matchesFilter && matchesSearch;
    }).toList();
  }

  bool get areAllVisibleDocumentsSelected {
    final visible = visibleDocuments;
    return visible.isNotEmpty && visible.every((document) => selectedDocumentIds.contains(document.id));
  }

  HomeState copyWith({
    List<AppDocument>? documents,
    DocumentFilter? documentFilter,
    bool? isLoading,
    bool? isAddDocumentOverlayVisible,
    bool? isSearchVisible,
    bool? isSelectMode,
    Set<int>? selectedDocumentIds,
    Object? documentContextMenuId = _notSet,
    Object? documentContextMenuAnchor = _notSet,
    String? searchQuery,
    Object? failure = _notSet,
  }) {
    return HomeState(
      documents: documents ?? this.documents,
      documentFilter: documentFilter ?? this.documentFilter,
      isLoading: isLoading ?? this.isLoading,
      isAddDocumentOverlayVisible: isAddDocumentOverlayVisible ?? this.isAddDocumentOverlayVisible,
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
      failure: identical(failure, _notSet) ? this.failure : failure as Failure?,
    );
  }

  @override
  List<Object?> get props {
    return [
      documents,
      documentFilter,
      isLoading,
      isAddDocumentOverlayVisible,
      isSearchVisible,
      isSelectMode,
      selectedDocumentIds,
      documentContextMenuId,
      documentContextMenuAnchor,
      searchQuery,
      failure,
    ];
  }
}

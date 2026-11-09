import 'dart:ui';

import 'package:test_task/core/error/result.dart';

import '../entities/app_document.dart';

abstract interface class DocumentRepository {
  Stream<Result<List<AppDocument>>> watchDocuments();

  Future<Result<void>> importPdfFiles(int previewBackgroundColorArgb);

  Future<Result<void>> importPhotoFiles(int previewBackgroundColorArgb);

  Future<Result<void>> scanDocument(int previewBackgroundColorArgb);

  Future<Result<void>> toggleDocumentSignature(int documentId);

  Future<Result<void>> deleteDocuments(Set<int> documentIds);

  Future<Result<void>> shareDocuments(
    Set<int> documentIds,
    Rect sharePositionOrigin,
  );

  Future<Result<void>> printDocument(int documentId);
}

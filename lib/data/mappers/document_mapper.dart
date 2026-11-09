import 'package:test_task/data/database/app_database.dart';
import 'package:test_task/data/models/stored_document_path.dart';
import 'package:test_task/domain/entities/app_document.dart';

extension DocumentRecordMapper on DocumentRecord {
  Future<AppDocument> toEntity(Future<String> Function(StoredDocumentPath) resolveStoredPath) async {
    final storedLastPreviewPath = lastPreviewPath;
    return AppDocument(
      id: id,
      title: title,
      pdfPath: await resolveStoredPath(StoredDocumentPath(pdfPath)),
      firstPreviewPath: await resolveStoredPath(StoredDocumentPath(firstPreviewPath)),
      lastPreviewPath: storedLastPreviewPath == null
          ? null
          : await resolveStoredPath(StoredDocumentPath(storedLastPreviewPath)),
      createdAt: createdAt,
      isSigned: isSigned,
    );
  }
}

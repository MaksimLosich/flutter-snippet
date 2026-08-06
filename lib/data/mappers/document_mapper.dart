import 'package:test_task/data/database/app_database.dart';
import 'package:test_task/domain/entities/app_document.dart';

extension DocumentRecordMapper on DocumentRecord {
  AppDocument toEntity() {
    return AppDocument(
      id: id,
      title: title,
      pdfPath: pdfPath,
      firstPreviewPath: firstPreviewPath,
      lastPreviewPath: lastPreviewPath,
      createdAt: createdAt,
      isSigned: isSigned,
    );
  }
}

import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:test_task/data/database/app_database.dart';
import 'package:test_task/data/datasources/document_file_datasource.dart';
import 'package:test_task/data/datasources/document_local_datasource.dart';
import 'package:test_task/data/datasources/document_picker_datasource.dart';
import 'package:test_task/data/datasources/document_print_datasource.dart';
import 'package:test_task/data/datasources/document_scanner_datasource.dart';
import 'package:test_task/data/datasources/document_share_datasource.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/domain/repositories/document_repository.dart';

@LazySingleton(as: DocumentRepository)
final class DocumentRepositoryImpl implements DocumentRepository {
  static const _newDocumentTitle = 'New Document';

  const DocumentRepositoryImpl(
    this._pickerDataSource,
    this._scannerDataSource,
    this._printDataSource,
    this._shareDataSource,
    this._fileDataSource,
    this._localDataSource,
  );

  final DocumentPickerDataSource _pickerDataSource;
  final DocumentScannerDataSource _scannerDataSource;
  final DocumentPrintDataSource _printDataSource;
  final DocumentShareDataSource _shareDataSource;
  final DocumentFileDataSource _fileDataSource;
  final DocumentLocalDataSource _localDataSource;

  @override
  Stream<List<AppDocument>> watchDocuments() {
    return _localDataSource.watchDocuments().asyncMap(_resolveValidDocuments);
  }

  @override
  Future<void> importPdfFiles() async {
    final pdfPaths = await _pickerDataSource.pickPdfFiles();

    for (final pdfPath in pdfPaths) {
      await _savePdf(pdfPath);
    }
  }

  @override
  Future<void> importPhotoFiles() async {
    final imagePaths = await _pickerDataSource.pickImageFiles();
    await _saveImagesAsPdf(imagePaths);
  }

  @override
  Future<void> scanDocument() async {
    final imagePaths = await _scannerDataSource.scanImages();
    await _saveImagesAsPdf(imagePaths);
  }

  @override
  Future<void> toggleDocumentSignature(int documentId) async {
    final records = await _localDataSource.getDocuments();
    DocumentRecord? record;
    for (final item in records) {
      if (item.id == documentId) {
        record = item;
        break;
      }
    }

    if (record == null) {
      return;
    }

    await _localDataSource.setDocumentSigned(
      id: documentId,
      isSigned: !record.isSigned,
    );
  }

  @override
  Future<void> deleteDocuments(Set<int> documentIds) async {
    if (documentIds.isEmpty) {
      return;
    }

    final records = await _localDataSource.getDocumentsByIds(documentIds);
    final paths = records
        .expand(
          (record) => [
            record.pdfPath,
            record.firstPreviewPath,
            record.lastPreviewPath,
          ],
        )
        .toList();

    await _fileDataSource.deleteFiles(paths);
    await _localDataSource.deleteDocumentsByIds(documentIds.toList());
  }

  @override
  Future<void> shareDocuments(Set<int> documentIds) async {
    if (documentIds.isEmpty) {
      return;
    }

    final records = await _localDataSource.getDocumentsByIds(documentIds);
    final pdfPaths = <String>[];
    for (final record in records) {
      pdfPaths.add(await _fileDataSource.resolvePath(record.pdfPath));
    }

    await _shareDataSource.sharePdfFiles(pdfPaths);
  }

  @override
  Future<void> printDocument(int documentId) async {
    final records = await _localDataSource.getDocumentsByIds({documentId});
    if (records.isEmpty) {
      return;
    }

    final record = records.first;
    await _printDataSource.printPdfFile(
      pdfPath: await _fileDataSource.resolvePath(record.pdfPath),
      name: record.title,
    );
  }

  Future<void> _saveImagesAsPdf(List<String> imagePaths) async {
    if (imagePaths.isEmpty) {
      return;
    }

    final pdfPath = await _fileDataSource.createPdfFromImages(imagePaths);
    await _insertPreparedPdf(title: _newDocumentTitle, pdfPath: pdfPath);
  }

  Future<void> _savePdf(String sourcePdfPath) async {
    final pdfPath = await _fileDataSource.copyPdfToStorage(sourcePdfPath);
    await _insertPreparedPdf(
      title: p.basenameWithoutExtension(sourcePdfPath),
      pdfPath: pdfPath,
    );
  }

  Future<void> _insertPreparedPdf({
    required String title,
    required String pdfPath,
  }) async {
    final previews = await _fileDataSource.createPdfPreviews(pdfPath);
    final uniqueTitle = await _resolveUniqueTitle(
      title.trim().isEmpty ? _fallbackTitle(pdfPath) : title,
    );
    await _localDataSource.insertDocument(
      title: uniqueTitle,
      pdfPath: pdfPath,
      firstPreviewPath: previews.firstPreviewPath,
      lastPreviewPath: previews.lastPreviewPath,
    );
  }

  String _fallbackTitle(String path) {
    return p.basenameWithoutExtension(path);
  }

  Future<String> _resolveUniqueTitle(String rawTitle) async {
    final title = rawTitle.trim().isEmpty ? _newDocumentTitle : rawTitle.trim();
    final existingTitles = (await _localDataSource.getDocumentTitles()).toSet();

    if (!existingTitles.contains(title)) {
      return title;
    }

    var index = 2;
    while (existingTitles.contains('$title $index')) {
      index++;
    }
    final uniqueTitle = '$title $index';
    return uniqueTitle;
  }

  Future<List<AppDocument>> _resolveValidDocuments(
    List<DocumentRecord> records,
  ) async {
    final validRecords = <DocumentRecord>[];
    final invalidIds = <int>[];

    for (final record in records) {
      if (await _hasRequiredFiles(record)) {
        validRecords.add(record);
      } else {
        invalidIds.add(record.id);
      }
    }

    if (invalidIds.isNotEmpty) {
      await _localDataSource.deleteDocumentsByIds(invalidIds);
    }

    return Future.wait(validRecords.map(_toEntity));
  }

  Future<bool> _hasRequiredFiles(DocumentRecord record) async {
    final pdfPath = await _fileDataSource.resolvePath(record.pdfPath);
    final firstPreviewPath = await _fileDataSource.resolvePath(
      record.firstPreviewPath,
    );
    final lastPreviewPath = record.lastPreviewPath == null
        ? null
        : await _fileDataSource.resolvePath(record.lastPreviewPath!);

    final hasPdf = await File(pdfPath).exists();
    final hasFirstPreview = await File(firstPreviewPath).exists();
    final hasLastPreview =
        lastPreviewPath == null || await File(lastPreviewPath).exists();
    return hasPdf && hasFirstPreview && hasLastPreview;
  }

  Future<AppDocument> _toEntity(DocumentRecord record) async {
    return AppDocument(
      id: record.id,
      title: record.title,
      pdfPath: await _fileDataSource.resolvePath(record.pdfPath),
      firstPreviewPath: await _fileDataSource.resolvePath(
        record.firstPreviewPath,
      ),
      lastPreviewPath: record.lastPreviewPath == null
          ? null
          : await _fileDataSource.resolvePath(record.lastPreviewPath!),
      createdAt: record.createdAt,
      isSigned: record.isSigned,
    );
  }
}

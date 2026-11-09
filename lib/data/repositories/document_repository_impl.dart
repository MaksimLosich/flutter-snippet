import 'dart:async';
import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:test_task/core/error/result.dart';
import 'package:test_task/data/database/app_database.dart';
import 'package:test_task/data/datasources/document_file_datasource.dart';
import 'package:test_task/data/datasources/document_local_datasource.dart';
import 'package:test_task/data/datasources/document_pdf_processor.dart';
import 'package:test_task/data/datasources/document_picker_datasource.dart';
import 'package:test_task/data/datasources/document_print_datasource.dart';
import 'package:test_task/data/datasources/document_scanner_datasource.dart';
import 'package:test_task/data/datasources/document_share_datasource.dart';
import 'package:test_task/data/mappers/document_mapper.dart';
import 'package:test_task/data/models/preview_page.dart';
import 'package:test_task/data/models/stored_document_path.dart';
import 'package:test_task/domain/entities/app_document.dart';
import 'package:test_task/domain/failures/document_failure.dart';
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
    this._pdfProcessor,
    this._localDataSource,
  );

  final DocumentPickerDataSource _pickerDataSource;
  final DocumentScannerDataSource _scannerDataSource;
  final DocumentPrintDataSource _printDataSource;
  final DocumentShareDataSource _shareDataSource;
  final DocumentFileDataSource _fileDataSource;
  final DocumentPdfProcessor _pdfProcessor;
  final DocumentLocalDataSource _localDataSource;

  @override
  Stream<Result<List<AppDocument>>> watchDocuments() {
    try {
      return _localDataSource
          .watchDocuments()
          .asyncMap<Result<List<AppDocument>>>((records) async {
            try {
              return Ok(await _resolveDocuments(records));
            } catch (error, stackTrace) {
              return Err(DocumentFailure(DocumentOperation.load, error, stackTrace));
            }
          })
          .transform(
            StreamTransformer.fromHandlers(
              handleError: (Object error, StackTrace stackTrace, EventSink<Result<List<AppDocument>>> sink) {
                sink.add(Err(DocumentFailure(DocumentOperation.load, error, stackTrace)));
              },
            ),
          );
    } catch (error, stackTrace) {
      return Stream.value(Err(DocumentFailure(DocumentOperation.load, error, stackTrace)));
    }
  }

  @override
  Future<Result<void>> importPdfFiles(int previewBackgroundColorArgb) {
    return _run(DocumentOperation.import, () async {
      final pdfPaths = await _pickerDataSource.pickPdfFiles();

      for (final pdfPath in pdfPaths) {
        await _savePdf(pdfPath, previewBackgroundColorArgb);
      }
    });
  }

  @override
  Future<Result<void>> importPhotoFiles(int previewBackgroundColorArgb) {
    return _run(DocumentOperation.import, () async {
      final imagePaths = await _pickerDataSource.pickImageFiles();
      await _saveImagesAsPdf(imagePaths, previewBackgroundColorArgb);
    });
  }

  @override
  Future<Result<void>> scanDocument(int previewBackgroundColorArgb) {
    return _run(DocumentOperation.scan, () async {
      final imagePaths = await _scannerDataSource.scanImages();
      try {
        await _saveImagesAsPdf(imagePaths, previewBackgroundColorArgb);
      } finally {
        await _scannerDataSource.deleteScannedImages(imagePaths);
      }
    });
  }

  @override
  Future<Result<void>> toggleDocumentSignature(int documentId) {
    return _run(DocumentOperation.update, () async {
      final records = await _localDataSource.getDocumentsByIds({documentId});
      if (records.isNotEmpty) {
        await _localDataSource.setDocumentSigned(id: documentId, isSigned: !records.first.isSigned);
      }
    });
  }

  @override
  Future<Result<void>> deleteDocuments(Set<int> documentIds) {
    return _run(DocumentOperation.delete, () async {
      if (documentIds.isNotEmpty) {
        final records = await _localDataSource.getDocumentsByIds(documentIds);
        final paths = records
            .expand((record) => [record.pdfPath, record.firstPreviewPath, record.lastPreviewPath])
            .whereType<String>()
            .map(StoredDocumentPath.new)
            .toList();

        await _fileDataSource.deleteStoredFiles(paths);
        await _localDataSource.deleteDocumentsByIds(documentIds.toList());
      }
    });
  }

  @override
  Future<Result<void>> shareDocuments(Set<int> documentIds, Rect sharePositionOrigin) {
    return _run(DocumentOperation.share, () async {
      if (documentIds.isNotEmpty) {
        final records = await _localDataSource.getDocumentsByIds(documentIds);
        final pdfPaths = <String>[];
        for (final record in records) {
          pdfPaths.add(await _fileDataSource.resolveStoredPath(StoredDocumentPath(record.pdfPath)));
        }

        await _shareDataSource.sharePdfFiles(pdfPaths, sharePositionOrigin);
      }
    });
  }

  @override
  Future<Result<void>> printDocument(int documentId) {
    return _run(DocumentOperation.print, () async {
      final records = await _localDataSource.getDocumentsByIds({documentId});
      if (records.isNotEmpty) {
        final record = records.first;
        await _printDataSource.printPdfFile(
          pdfPath: await _fileDataSource.resolveStoredPath(StoredDocumentPath(record.pdfPath)),
          name: record.title,
        );
      }
    });
  }

  Future<Result<void>> _run(DocumentOperation operation, Future<void> Function() action) async {
    try {
      await action();
      return const Ok<void>(null);
    } catch (error, stackTrace) {
      return Err(DocumentFailure(operation, error, stackTrace));
    }
  }

  Future<void> _saveImagesAsPdf(List<String> imagePaths, int previewBackgroundColorArgb) async {
    if (imagePaths.isEmpty) {
      return;
    }

    await _insertPreparedPdf(
      title: _newDocumentTitle,
      previewBackgroundColorArgb: previewBackgroundColorArgb,
      createPdf: () async {
        final bytes = await _pdfProcessor.createPdfFromImages(imagePaths);
        return _fileDataSource.writePdf(bytes);
      },
    );
  }

  Future<void> _savePdf(String sourcePdfPath, int previewBackgroundColorArgb) async {
    await _insertPreparedPdf(
      title: p.basenameWithoutExtension(sourcePdfPath),
      previewBackgroundColorArgb: previewBackgroundColorArgb,
      createPdf: () => _fileDataSource.copyPdfToStorage(sourcePdfPath),
    );
  }

  Future<void> _insertPreparedPdf({
    required String title,
    required int previewBackgroundColorArgb,
    required Future<StoredDocumentPath> Function() createPdf,
  }) async {
    final createdPaths = <StoredDocumentPath>[];
    try {
      final pdfPath = await createPdf();
      createdPaths.add(pdfPath);

      final absolutePdfPath = await _fileDataSource.resolveStoredPath(pdfPath);
      final previews = await _pdfProcessor.renderPreviews(
        absolutePdfPath,
        backgroundColorArgb: previewBackgroundColorArgb,
      );
      final firstPreviewPath = await _fileDataSource.writePreview(
        previews.first,
        pdfPath: pdfPath,
        page: PreviewPage.first,
      );
      createdPaths.add(firstPreviewPath);

      StoredDocumentPath? lastPreviewPath;
      if (previews.last case final lastBytes?) {
        lastPreviewPath = await _fileDataSource.writePreview(lastBytes, pdfPath: pdfPath, page: PreviewPage.last);
        createdPaths.add(lastPreviewPath);
      }

      final uniqueTitle = await _resolveUniqueTitle(title);
      await _localDataSource.insertDocument(
        title: uniqueTitle,
        pdfPath: pdfPath.value,
        firstPreviewPath: firstPreviewPath.value,
        lastPreviewPath: lastPreviewPath?.value,
      );
    } catch (error, stackTrace) {
      try {
        await _fileDataSource.deleteStoredFiles(createdPaths);
      } catch (_) {
        Error.throwWithStackTrace(error, stackTrace);
      }
      rethrow;
    }
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

  Future<List<AppDocument>> _resolveDocuments(List<DocumentRecord> records) {
    return Future.wait(records.map((record) => record.toEntity(_fileDataSource.resolveStoredPath)));
  }
}

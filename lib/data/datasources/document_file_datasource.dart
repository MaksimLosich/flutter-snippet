import 'dart:io';
import 'dart:math' as math;

import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdfx;

final class DocumentPreviewFiles {
  const DocumentPreviewFiles({
    required this.firstPreviewPath,
    required this.lastPreviewPath,
  });

  final String firstPreviewPath;
  final String? lastPreviewPath;
}

abstract interface class DocumentFileDataSource {
  Future<String> copyPdfToStorage(String sourcePath);

  Future<String> createPdfFromImages(List<String> imagePaths);

  Future<DocumentPreviewFiles> createPdfPreviews(String pdfPath);

  Future<String> resolvePath(String storedPath);

  Future<void> deleteFiles(List<String?> storedPaths);
}

@LazySingleton(as: DocumentFileDataSource)
final class LocalDocumentFileDataSource implements DocumentFileDataSource {
  static const _previewWidth = 600.0;
  static const _documentsDirectoryName = 'documents';
  static const _previewsDirectoryName = 'document_previews';

  @override
  Future<String> copyPdfToStorage(String sourcePath) async {
    final sourceFile = File(sourcePath);
    final fileName = _uniqueFileName(
      p.basenameWithoutExtension(sourcePath),
      '.pdf',
    );
    final relativePath = p.join(_documentsDirectoryName, fileName);
    final destination = File(await resolvePath(relativePath));

    await destination.parent.create(recursive: true);
    await sourceFile.copy(destination.path);
    return relativePath;
  }

  @override
  Future<String> createPdfFromImages(List<String> imagePaths) async {
    final document = pw.Document();

    for (final imagePath in imagePaths) {
      final image = pw.MemoryImage(await File(imagePath).readAsBytes());
      document.addPage(
        pw.Page(
          pageFormat: pdf.PdfPageFormat.a4,
          build: (_) {
            return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
          },
        ),
      );
    }

    final fileName = _uniqueFileName('document', '.pdf');
    final relativePath = p.join(_documentsDirectoryName, fileName);
    final file = File(await resolvePath(relativePath));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(await document.save(), flush: true);

    return relativePath;
  }

  @override
  Future<DocumentPreviewFiles> createPdfPreviews(String pdfPath) async {
    final absolutePdfPath = await resolvePath(pdfPath);

    final document = await pdfx.PdfDocument.openFile(absolutePdfPath);

    try {
      final firstPreviewPath = await _renderPagePreview(
        document: document,
        pageNumber: 1,
        pdfPath: pdfPath,
        suffix: 'first',
      );

      final lastPreviewPath = document.pagesCount > 1
          ? await _renderPagePreview(
              document: document,
              pageNumber: document.pagesCount,
              pdfPath: pdfPath,
              suffix: 'last',
            )
          : null;

      return DocumentPreviewFiles(
        firstPreviewPath: firstPreviewPath,
        lastPreviewPath: lastPreviewPath,
      );
    } finally {
      await document.close();
    }
  }

  @override
  Future<String> resolvePath(String storedPath) async {
    if (!p.isAbsolute(storedPath)) {
      return p.join(await _applicationDocumentsPath, storedPath);
    }

    if (await File(storedPath).exists()) {
      return storedPath;
    }

    final recoveredPath = await _recoverMovedContainerPath(storedPath);
    return recoveredPath ?? storedPath;
  }

  @override
  Future<void> deleteFiles(List<String?> storedPaths) async {
    for (final storedPath in storedPaths.whereType<String>()) {
      final path = await resolvePath(storedPath);
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<String> _renderPagePreview({
    required pdfx.PdfDocument document,
    required int pageNumber,
    required String pdfPath,
    required String suffix,
  }) async {
    final page = await document.getPage(pageNumber);

    try {
      final scale = _previewWidth / math.max(page.width, 1);
      final pageImage = await page.render(
        width: _previewWidth,
        height: page.height * scale,
        format: pdfx.PdfPageImageFormat.jpeg,
        backgroundColor: '#FFFFFF',
        quality: 90,
      );

      if (pageImage == null) {
        throw StateError('Could not render PDF preview');
      }

      final fileName = _uniqueFileName(
        '${p.basenameWithoutExtension(pdfPath)}_$suffix',
        '.jpg',
      );
      final relativePath = p.join(_previewsDirectoryName, fileName);
      final file = File(await resolvePath(relativePath));
      await file.parent.create(recursive: true);
      await file.writeAsBytes(pageImage.bytes, flush: true);

      return relativePath;
    } finally {
      await page.close();
    }
  }

  Future<String> get _applicationDocumentsPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String?> _recoverMovedContainerPath(String absolutePath) async {
    final basename = p.basename(absolutePath);
    final extension = p.extension(absolutePath).toLowerCase();
    final directoryName = switch (extension) {
      '.pdf' => _documentsDirectoryName,
      '.jpg' || '.jpeg' || '.png' => _previewsDirectoryName,
      _ => null,
    };

    if (directoryName == null) {
      return null;
    }

    final candidate = p.join(
      await _applicationDocumentsPath,
      directoryName,
      basename,
    );
    return await File(candidate).exists() ? candidate : null;
  }

  String _uniqueFileName(String rawName, String extension) {
    final safeName = rawName
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final name = safeName.isEmpty ? 'document' : safeName;
    return '${DateTime.now().microsecondsSinceEpoch}_$name$extension';
  }
}

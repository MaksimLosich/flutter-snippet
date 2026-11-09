import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:test_task/data/models/document_preview_images.dart';

abstract interface class DocumentPdfProcessor {
  Future<Uint8List> createPdfFromImages(List<String> imageAbsolutePaths);

  Future<DocumentPreviewImages> renderPreviews(String pdfAbsolutePath, {required int backgroundColorArgb});
}

@LazySingleton(as: DocumentPdfProcessor)
final class LocalDocumentPdfProcessor implements DocumentPdfProcessor {
  static const _previewWidth = 600.0;
  static const _previewQuality = 90;

  @override
  Future<Uint8List> createPdfFromImages(List<String> imageAbsolutePaths) async {
    final document = pw.Document();

    for (final imageAbsolutePath in imageAbsolutePaths) {
      final image = pw.MemoryImage(await File(imageAbsolutePath).readAsBytes());
      document.addPage(
        pw.Page(
          pageFormat: pdf.PdfPageFormat.a4,
          build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
        ),
      );
    }

    return document.save();
  }

  @override
  Future<DocumentPreviewImages> renderPreviews(String pdfAbsolutePath, {required int backgroundColorArgb}) async {
    final document = await pdfx.PdfDocument.openFile(pdfAbsolutePath);

    try {
      final backgroundColor = '#${(backgroundColorArgb & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
      final first = await _renderPage(document, 1, backgroundColor);
      final last = document.pagesCount > 1 ? await _renderPage(document, document.pagesCount, backgroundColor) : null;
      return DocumentPreviewImages(first: first, last: last);
    } finally {
      await document.close();
    }
  }

  Future<Uint8List> _renderPage(pdfx.PdfDocument document, int pageNumber, String backgroundColor) async {
    final page = await document.getPage(pageNumber);

    try {
      final scale = _previewWidth / math.max(page.width, 1);
      final image = await page.render(
        width: _previewWidth,
        height: page.height * scale,
        format: pdfx.PdfPageImageFormat.jpeg,
        backgroundColor: backgroundColor,
        quality: _previewQuality,
      );

      if (image == null) {
        throw StateError('Could not render PDF preview');
      }
      return image.bytes;
    } finally {
      await page.close();
    }
  }
}

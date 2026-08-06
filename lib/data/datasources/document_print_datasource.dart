import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:printing/printing.dart';

abstract interface class DocumentPrintDataSource {
  Future<void> printPdfFile({required String pdfPath, required String name});
}

@LazySingleton(as: DocumentPrintDataSource)
final class PlatformDocumentPrintDataSource implements DocumentPrintDataSource {
  @override
  Future<void> printPdfFile({
    required String pdfPath,
    required String name,
  }) async {
    await Printing.layoutPdf(
      name: name,
      onLayout: (_) {
        return File(pdfPath).readAsBytes();
      },
    );
  }
}

import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

abstract interface class DocumentShareDataSource {
  Future<void> sharePdfFiles(List<String> pdfPaths, Rect sharePositionOrigin);
}

@LazySingleton(as: DocumentShareDataSource)
final class PlatformDocumentShareDataSource implements DocumentShareDataSource {
  @override
  Future<void> sharePdfFiles(List<String> pdfPaths, Rect sharePositionOrigin) async {
    if (pdfPaths.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(files: pdfPaths.map((path) => XFile(path)).toList(), sharePositionOrigin: sharePositionOrigin),
      );
    }
  }
}

import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

abstract interface class DocumentShareDataSource {
  Future<void> sharePdfFiles(List<String> pdfPaths);
}

@LazySingleton(as: DocumentShareDataSource)
final class PlatformDocumentShareDataSource implements DocumentShareDataSource {
  @override
  Future<void> sharePdfFiles(List<String> pdfPaths) async {
    if (pdfPaths.isEmpty) {
      return;
    }

    await SharePlus.instance.share(
      ShareParams(files: pdfPaths.map((path) => XFile(path)).toList()),
    );
  }
}

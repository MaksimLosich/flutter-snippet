import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:injectable/injectable.dart';

abstract interface class DocumentScannerDataSource {
  Future<List<String>> scanImages();
}

@LazySingleton(as: DocumentScannerDataSource)
final class CunningDocumentScannerDataSource
    implements DocumentScannerDataSource {
  @override
  Future<List<String>> scanImages() async {
    return await CunningDocumentScanner.getPictures() ?? const [];
  }
}

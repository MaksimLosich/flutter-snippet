import '../entities/app_document.dart';

abstract interface class DocumentRepository {
  Stream<List<AppDocument>> watchDocuments();

  Future<void> importPdfFiles();

  Future<void> importPhotoFiles();

  Future<void> scanDocument();

  Future<void> toggleDocumentSignature(int documentId);

  Future<void> deleteDocuments(Set<int> documentIds);

  Future<void> shareDocuments(Set<int> documentIds);

  Future<void> printDocument(int documentId);
}

import 'package:injectable/injectable.dart';

import '../repositories/document_repository.dart';

@injectable
final class PrintDocumentUseCase {
  const PrintDocumentUseCase(this._repository);

  final DocumentRepository _repository;

  Future<void> call(int documentId) {
    return _repository.printDocument(documentId);
  }
}

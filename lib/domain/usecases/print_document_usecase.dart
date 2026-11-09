import 'package:injectable/injectable.dart';
import 'package:test_task/core/error/result.dart';

import '../repositories/document_repository.dart';

@injectable
final class PrintDocumentUseCase {
  const PrintDocumentUseCase(this._repository);

  final DocumentRepository _repository;

  Future<Result<void>> call(int documentId) {
    return _repository.printDocument(documentId);
  }
}

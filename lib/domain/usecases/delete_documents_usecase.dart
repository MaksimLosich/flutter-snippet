import 'package:injectable/injectable.dart';
import 'package:test_task/core/error/result.dart';

import '../repositories/document_repository.dart';

@injectable
final class DeleteDocumentsUseCase {
  const DeleteDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Future<Result<void>> call(Set<int> documentIds) {
    return _repository.deleteDocuments(documentIds);
  }
}

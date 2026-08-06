import 'package:injectable/injectable.dart';

import '../repositories/document_repository.dart';

@injectable
final class DeleteDocumentsUseCase {
  const DeleteDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Future<void> call(Set<int> documentIds) {
    return _repository.deleteDocuments(documentIds);
  }
}

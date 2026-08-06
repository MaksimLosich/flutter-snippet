import 'package:injectable/injectable.dart';

import '../repositories/document_repository.dart';

@injectable
final class ImportPdfDocumentsUseCase {
  const ImportPdfDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Future<void> call() {
    return _repository.importPdfFiles();
  }
}

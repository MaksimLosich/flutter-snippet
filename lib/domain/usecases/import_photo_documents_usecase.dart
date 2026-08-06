import 'package:injectable/injectable.dart';

import '../repositories/document_repository.dart';

@injectable
final class ImportPhotoDocumentsUseCase {
  const ImportPhotoDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Future<void> call() {
    return _repository.importPhotoFiles();
  }
}

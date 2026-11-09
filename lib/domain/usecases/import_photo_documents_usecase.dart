import 'package:injectable/injectable.dart';
import 'package:test_task/core/error/result.dart';

import '../repositories/document_repository.dart';

@injectable
final class ImportPhotoDocumentsUseCase {
  const ImportPhotoDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Future<Result<void>> call(int previewBackgroundColorArgb) {
    return _repository.importPhotoFiles(previewBackgroundColorArgb);
  }
}

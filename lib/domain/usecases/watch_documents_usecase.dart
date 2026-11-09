import 'package:injectable/injectable.dart';
import 'package:test_task/core/error/result.dart';

import '../entities/app_document.dart';
import '../repositories/document_repository.dart';

@injectable
final class WatchDocumentsUseCase {
  const WatchDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Stream<Result<List<AppDocument>>> call() {
    return _repository.watchDocuments();
  }
}

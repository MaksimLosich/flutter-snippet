import 'package:injectable/injectable.dart';

import '../entities/app_document.dart';
import '../repositories/document_repository.dart';

@injectable
final class WatchDocumentsUseCase {
  const WatchDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Stream<List<AppDocument>> call() {
    return _repository.watchDocuments();
  }
}

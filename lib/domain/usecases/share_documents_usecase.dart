import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:test_task/core/error/result.dart';

import '../repositories/document_repository.dart';

@injectable
final class ShareDocumentsUseCase {
  const ShareDocumentsUseCase(this._repository);

  final DocumentRepository _repository;

  Future<Result<void>> call(Set<int> documentIds, Rect sharePositionOrigin) {
    return _repository.shareDocuments(documentIds, sharePositionOrigin);
  }
}

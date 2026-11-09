import 'package:test_task/core/error/failure.dart';

enum DocumentOperation { load, import, scan, update, delete, share, print }

final class DocumentFailure extends Failure {
  const DocumentFailure(this.operation, super.cause, super.stackTrace);

  final DocumentOperation operation;
}

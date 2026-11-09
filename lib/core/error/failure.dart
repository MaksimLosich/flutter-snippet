abstract base class Failure {
  const Failure(this.cause, this.stackTrace);

  final Object? cause;
  final StackTrace? stackTrace;
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.cause, super.stackTrace);
}

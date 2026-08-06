sealed class Failure {
  const Failure({required this.message, this.cause});

  final String message;
  final Object? cause;
}

final class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.cause});
}

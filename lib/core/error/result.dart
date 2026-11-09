import 'failure.dart';

sealed class Result<T> {
  const Result();

  R on<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Ok<T>(:final data) => success(data),
      Err<T>(failure: final error) => failure(error),
    };
  }
}

final class Ok<T> extends Result<T> {
  const Ok(this.data);

  final T data;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}

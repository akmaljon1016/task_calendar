sealed class Result<S, E extends Exception> {
  const Result();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);

  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.exception);

  final E exception;
}

class CalendarException implements Exception {
  String message;

  CalendarException({required this.message});
}

class NoInternetException implements Exception {
  String message;

  NoInternetException({required this.message});
}

class Either<T, F> {
  T value;
  F fail;

  Either(this.value, this.fail);

  void check(
      {required Function(T value) success, required Function(F fail) failure}) {
    if (fail != null && this.fail != null) {
      failure(this.fail);
    } else if (value != null) {
      success(value);
    }
  }
}

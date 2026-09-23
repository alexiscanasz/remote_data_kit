part of 'result.dart';

final class Failure<T> extends Result<T> {
  const Failure(this.message, {this.type = FailureType.unknown});

  final String message;
  final FailureType type;
}

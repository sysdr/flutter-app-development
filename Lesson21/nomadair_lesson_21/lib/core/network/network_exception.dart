import '../repositories/repository_exception.dart';

sealed class NetworkException extends RepositoryException {
  const NetworkException(super.message);
}

final class HttpStatusException extends NetworkException {
  const HttpStatusException(this.statusCode, super.message);
  final int statusCode;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;
}

final class NetworkTimeoutException extends NetworkException {
  const NetworkTimeoutException() : super('Request timed out');
}

final class NetworkParseException extends NetworkException {
  const NetworkParseException(super.message);
}

final class NetworkAuthException extends NetworkException {
  const NetworkAuthException(super.message);
}

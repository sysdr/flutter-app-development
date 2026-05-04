/// Typed error for data-layer failures.
/// Thrown by repository implementations on network / parse errors.
/// The UI catches [RepositoryException] specifically; other exceptions
/// propagate as programming errors rather than user-facing messages.
final class RepositoryException implements Exception {
  const RepositoryException(this.message, {this.statusCode});
  final String message;
  final int?   statusCode;
  @override
  String toString() => statusCode != null
      ? 'RepositoryException($statusCode): $message'
      : 'RepositoryException: $message';
}

/// An exception for a marker
class MarkerException implements Exception {
  /// Provide a message
  MarkerException(this.message);

  /// The error message
  final String message;
}

/// An exception for a marker
class MarkerException implements Exception {
  /// Provide a message
  const MarkerException(this.message);

  /// The error message
  final String message;

  @override
  String toString() {
    return "MarkerException: $message";
  }
}

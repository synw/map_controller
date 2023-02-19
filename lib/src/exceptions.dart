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

/// An exception for a not implemented feature
class NotImplementedException implements Exception {
  /// Default constructor
  const NotImplementedException(this.message);

  /// The error message
  final String message;

  @override
  String toString() {
    return "NotImplementedException: $message";
  }
}

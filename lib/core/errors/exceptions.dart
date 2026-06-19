class DatabaseException implements Exception {
  const DatabaseException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'DatabaseException: $message';
}

class RemoteException implements Exception {
  const RemoteException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'RemoteException: $message';
}

abstract class Failure implements Exception {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(
      [super.message =
          'Could not reach the book library.\nCheck your connection.']);
}

class ServerFailure extends Failure {
  const ServerFailure(
      [super.message = 'The book library returned an unexpected response.']);
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server Exception', this.statusCode});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache Exception'});
}

class AuthException implements Exception {
  final String message;
  AuthException({this.message = 'Authentication Exception'});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Network Exception'});
}

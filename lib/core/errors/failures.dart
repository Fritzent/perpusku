import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Record not found']);
}

class ValidationFailure extends Failure {
  final Map<String, String> errors;
  const ValidationFailure(super.message, {this.errors = const {}});

  @override
  List<Object?> get props => [message, errors];
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Storage error']);
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
}

class StorageException implements Exception {
  final String message;
  const StorageException([this.message = 'Storage upload error']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Not found']);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([
    super.message = 'Email or password is incorrect',
  ]);
}

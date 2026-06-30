import 'package:perpusku/core/domain/entities/auth_user.dart';
import 'package:perpusku/core/domain/repositories/auth_repository.dart';
import 'package:perpusku/core/errors/failures.dart';
import 'package:perpusku/data/datasources/remote/auth/auth_local_datasource.dart';
import 'package:perpusku/data/datasources/remote/auth/auth_remote_datasource.dart';

import '../../../../core/utils/result.dart';
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      
      await localDataSource.saveSession(userModel);

      return Success(userModel);
    } on InvalidCredentialsException {
      return const Error(InvalidCredentialsFailure());
    } catch (_) {
      return const Error(ServerFailure('Server error', statusCode: 503));
    }
  }

  @override
  Future<bool> isLoggedIn() => localDataSource.isLoggedIn();

  @override
  Future<AuthUser?> getCachedSession() => localDataSource.getSession();

  @override
  Future<void> logout() => localDataSource.clearSession();
}

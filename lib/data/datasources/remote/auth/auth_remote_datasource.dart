import 'package:perpusku/data/models/auth_user_model.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const _mockEmail = 'user@example.com';
  static const _mockPassword = 'password123';

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == _mockEmail && password == _mockPassword) {
      return AuthUserModel(
        id: 'usr_001',
        email: email,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    }

    throw const InvalidCredentialsException();
  }
}

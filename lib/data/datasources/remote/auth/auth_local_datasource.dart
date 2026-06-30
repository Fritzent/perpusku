import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:perpusku/data/models/auth_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(AuthUserModel user);
  Future<AuthUserModel?> getSession();
  Future<bool> isLoggedIn();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({FlutterSecureStorage? secureStorage})
      : secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
            );

  static const _keyIsLoggedIn = 'auth_is_logged_in';
  static const _keyUserId = 'auth_user_id';
  static const _keyUserEmail = 'auth_user_email';
  static const _keyUserToken = 'auth_user_token';

  @override
  Future<void> saveSession(AuthUserModel user) async {
    await Future.wait([
      secureStorage.write(key: _keyIsLoggedIn, value: 'true'),
      secureStorage.write(key: _keyUserId, value: user.id),
      secureStorage.write(key: _keyUserEmail, value: user.email),
      secureStorage.write(key: _keyUserToken, value: user.token),
    ]);
  }

  @override
  Future<AuthUserModel?> getSession() async {
    final loggedIn = await secureStorage.read(key: _keyIsLoggedIn);
    if (loggedIn != 'true') return null;

    final id = await secureStorage.read(key: _keyUserId);
    final email = await secureStorage.read(key: _keyUserEmail);
    final token = await secureStorage.read(key: _keyUserToken);

    if (id == null || email == null || token == null) return null;

    return AuthUserModel(id: id, email: email, token: token);
  }

  @override
  Future<bool> isLoggedIn() async {
    final value = await secureStorage.read(key: _keyIsLoggedIn);
    return value == 'true';
  }

  @override
  Future<void> clearSession() async {
    await secureStorage.deleteAll();
  }
}

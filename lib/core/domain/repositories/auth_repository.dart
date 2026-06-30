import '../../../../core/utils/result.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  });

  Future<bool> isLoggedIn();

  Future<AuthUser?> getCachedSession();

  Future<void> logout();
}

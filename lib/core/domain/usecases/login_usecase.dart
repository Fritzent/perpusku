import 'package:perpusku/core/errors/failures.dart';
import 'package:perpusku/core/validator/validators.dart';

import '../../../../core/utils/result.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Result<AuthUser>> call({
    required String email,
    required String password,
  }) async {
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      return Error(ValidationFailure(emailError));
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      return Error(ValidationFailure(passwordError));
    }

    return repository.login(email: email.trim(), password: password);
  }
}

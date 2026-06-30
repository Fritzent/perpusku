import '../repositories/auth_repository.dart';

class CheckLoginStatusUseCase {
  final AuthRepository repository;

  const CheckLoginStatusUseCase(this.repository);

  Future<bool> call() => repository.isLoggedIn();
}

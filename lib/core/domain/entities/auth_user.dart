import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String token;

  const AuthUser({
    required this.id,
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [id, email, token];
}

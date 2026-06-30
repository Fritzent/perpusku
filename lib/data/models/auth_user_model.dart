import 'package:perpusku/core/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.token,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        token: json['token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'token': token,
      };
}

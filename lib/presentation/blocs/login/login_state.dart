import 'package:equatable/equatable.dart';

enum LoginStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isPasswordObscured;
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isPasswordObscured = true,
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  bool get isValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      emailError == null &&
      passwordError == null;

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    bool clearEmailError = false,
    String? passwordError,
    bool clearPasswordError = false,
    bool? isPasswordObscured,
    LoginStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      status: status ?? this.status,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailError,
        passwordError,
        isPasswordObscured,
        status,
        errorMessage,
      ];
}

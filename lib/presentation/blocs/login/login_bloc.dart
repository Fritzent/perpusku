import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perpusku/core/domain/entities/auth_user.dart';
import 'package:perpusku/core/domain/usecases/login_usecase.dart';
import 'package:perpusku/core/validator/validators.dart';

import '../../../../core/utils/result.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final error = Validators.validateEmail(event.email);
    emit(state.copyWith(
      email: event.email,
      emailError: error,
      clearEmailError: error == null,
      status: LoginStatus.initial,
      clearErrorMessage: true,
    ));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final error = Validators.validatePassword(event.password);
    emit(state.copyWith(
      password: event.password,
      passwordError: error,
      clearPasswordError: error == null,
      status: LoginStatus.initial,
      clearErrorMessage: true,
    ));
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final emailError = Validators.validateEmail(state.email);
    final passwordError = Validators.validatePassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(state.copyWith(
        emailError: emailError,
        clearEmailError: emailError == null,
        passwordError: passwordError,
        clearPasswordError: passwordError == null,
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, clearErrorMessage: true));

    final result = await loginUseCase(email: state.email, password: state.password);

    if (result is Success<AuthUser>) {
      emit(state.copyWith(status: LoginStatus.success));
    } else if (result is Error<AuthUser>) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: result.failure.message,
      ));
    }
  }
}

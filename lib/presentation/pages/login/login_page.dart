import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:perpusku/core/domain/usecases/login_usecase.dart';
import 'package:perpusku/core/router/app_router.dart';
import 'package:perpusku/data/datasources/remote/auth/auth_local_datasource.dart';
import 'package:perpusku/data/datasources/remote/auth/auth_remote_datasource.dart';
import 'package:perpusku/presentation/blocs/login/login_bloc.dart';
import 'package:perpusku/presentation/blocs/login/login_event.dart';
import 'package:perpusku/presentation/blocs/login/login_state.dart';
import 'package:perpusku/presentation/widgets/common/email_field.dart';
import 'package:perpusku/presentation/widgets/common/password_field.dart';

import '../../../data/repositories/auth_repository_impl.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        loginUseCase: LoginUseCase(
          AuthRepositoryImpl(
            remoteDataSource: AuthRemoteDataSourceImpl(),
            localDataSource: AuthLocalDataSourceImpl(),
          ),
        ),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            context.go(AppRoutes.home);

          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const EmailField(),
                  const SizedBox(height: 16),
                  const PasswordField(),
                  const SizedBox(height: 24),
                  const _SubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select((LoginBloc bloc) => bloc.state.status);
    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);
    final isSubmitting = status == LoginStatus.submitting;

    return FilledButton(
      onPressed: (isSubmitting || !isValid)
          ? null
          : () => context.read<LoginBloc>().add(const LoginSubmitted()),
      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
      child: isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Text('Log in'),
    );
  }
}

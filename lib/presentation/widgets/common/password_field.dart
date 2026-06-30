import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perpusku/presentation/blocs/login/login_bloc.dart';
import 'package:perpusku/presentation/blocs/login/login_event.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordError =
        context.select((LoginBloc bloc) => bloc.state.passwordError);
    final isObscured =
        context.select((LoginBloc bloc) => bloc.state.isPasswordObscured);

    return TextField(
      onChanged: (value) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(value)),
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        errorText: passwordError,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
          onPressed: () => context
              .read<LoginBloc>()
              .add(const LoginPasswordVisibilityToggled()),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

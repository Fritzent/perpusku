import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perpusku/presentation/blocs/login/login_bloc.dart';
import 'package:perpusku/presentation/blocs/login/login_event.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final emailError = context.select((LoginBloc bloc) => bloc.state.emailError);

    return TextField(
      onChanged: (value) =>
          context.read<LoginBloc>().add(LoginEmailChanged(value)),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'name@example.com',
        errorText: emailError,
        prefixIcon: const Icon(Icons.email_outlined),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

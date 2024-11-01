import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login_bloc.dart';
import '../../bloc/login_events.dart';
import '../../bloc/login_state.dart';
import '../../resources/images.dart';
import '../../resources/strings.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigiere zur About-Seite
          Navigator.of(context).pushReplacementNamed('/about');
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(Images.INTRO_IMG),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 80),
              child: Text(
                Strings.INTRO_TITLE,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text;
                final password = _passwordController.text;
                context.read<LoginBloc>().add(LoginSubmitted(username: username, password: password));
              },
              child: const Text('Anmelden'),
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return CircularProgressIndicator();
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

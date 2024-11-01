import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/service_base.dart';
import 'login_form.dart';
import '../../bloc/login_bloc.dart'; // Importiere den Bloc

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(ServiceBase()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: const LoginForm(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/service_base.dart';
import 'login_form.dart';
import '../../bloc/login_bloc.dart'; // Importiere den Bloc

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(ServiceBase()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo at the top
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 130),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150, // Adjust size as needed
                  height: 150,
                ),
              ),
              // Login form with some margin
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

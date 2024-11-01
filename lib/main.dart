import 'dart:async' show runZoned;
import 'package:flutter/material.dart';
import 'package:baulog/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc package
import 'core/services/service_base.dart';
import 'core/services/appointment_service.dart'; // Import your AppointmentService
import 'bloc/appointment_bloc.dart'; // Adjust the import according to your file structure

void main() async {
  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databaseService = ServiceBase(); // Access the database

    // Initialize Firebase if needed
    //await Firebase.initializeApp();

    // Create an instance of AppointmentService
    final appointmentService = AppointmentService();

    // Wrap MyApp with MultiProvider to provide the AppointmentBloc
    runApp(
      MultiProvider(
        providers: [
          BlocProvider<AppointmentBloc>(
            create: (context) => AppointmentBloc(appointmentService), // Pass the appointmentService here
          ),
          // Add other providers here if needed
        ],
        child: MyApp(),
      ),
    );
  });
}

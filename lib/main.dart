import 'dart:async' show runZoned;
import 'package:flutter/material.dart';
import 'package:baulog/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/service_base.dart';
import 'core/services/appointment_service.dart';
import 'bloc/appointment_bloc.dart';
import 'core/services/facility_service.dart'; // Import FacilityService
import 'bloc/facility_bloc.dart'; // Import FacilityBloc

void main() async {
  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databaseService = ServiceBase();

    // Initialize Firebase if needed
    // await Firebase.initializeApp();
    await databaseService.insertUser('de', 'pw');
    // Create instances of services
    final appointmentService = AppointmentService();
    final facilityService = FacilityService(); // Initialize with database connection

    runApp(
      MultiProvider(
        providers: [
          BlocProvider<AppointmentBloc>(
            create: (context) => AppointmentBloc(appointmentService),
          ),
          BlocProvider<FacilityBloc>(
            create: (context) => FacilityBloc(facilityService), // Add FacilityBloc here
          ),
          // Weitere Providers falls nötig
        ],
        child: MyApp(),
      ),
    );
  });
}

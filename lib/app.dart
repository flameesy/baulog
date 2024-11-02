// app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baulog/bloc/news_bloc.dart';
import 'package:baulog/core/services/news/news_services.dart';
import 'package:baulog/routes/routes.dart';
import 'package:baulog/themes/themes.dart';

// Import required services and BLoCs
import 'core/services/service_base.dart';
import 'core/services/appointment_service.dart';
import 'core/services/facility_service.dart';
import 'bloc/appointment_bloc.dart';
import 'bloc/facility_bloc.dart';

class MyApp extends StatelessWidget {
  final ServiceBase databaseService;

  // Pass ServiceBase instance to MyApp
  const MyApp({Key? key, required this.databaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize services with the database connection
    final appointmentService = AppointmentService();
    final facilityService = FacilityService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NewsBloc(newsRepository: NewsService()),
        ),
        BlocProvider(
          create: (_) => AppointmentBloc(appointmentService),
        ),
        BlocProvider(
          create: (_) => FacilityBloc(facilityService),
        ),
        // Add any additional providers if needed
      ],
      child: MaterialApp(
        title: 'Flutter Boilerplate',
        debugShowCheckedModeBanner: false,
        theme: Themes.buildLightTheme(),
        initialRoute: Routes.initialRoute,
        routes: Routes.buildRoutes,
        onUnknownRoute:
        Routes.unknownRoute as Route<dynamic>? Function(RouteSettings)?,
      ),
    );
  }
}

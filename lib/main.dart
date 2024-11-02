// main.dart
import 'dart:async' show runZoned;
import 'package:flutter/material.dart';
import 'package:baulog/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/service_base.dart';

void main() async {
  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databaseService = ServiceBase();

    // Initialize Firebase if needed
    // await Firebase.initializeApp();

    await databaseService.insertUser('de', 'pw');

    // Pass databaseService to MyApp
    runApp(MyApp(databaseService: databaseService,));
  });
}

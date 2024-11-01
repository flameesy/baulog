import 'dart:async' show runZoned;
import 'package:flutter/material.dart';
import 'package:baulog/app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/services/service_base.dart';

void main() async {
  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databaseService = ServiceBase(); // Access the database
    await databaseService.insertUser('example@example.com', 'deinPasswort123');
    runApp(MyApp());
  });
}

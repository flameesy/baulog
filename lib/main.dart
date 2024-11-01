import 'dart:async' show runZoned;
import 'package:flutter/material.dart';
import 'package:baulog/app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
  });
}

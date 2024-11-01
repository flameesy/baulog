import 'package:sqflite/sqflite.dart';
import '../models/appointment_model.dart';
import '../../core/services/service_base.dart';

class AppointmentService {
  final ServiceBase _databaseHelper = ServiceBase();

  AppointmentService();

  Future<List<Appointment>> fetchAppointments() async {
    final List<Map<String, dynamic>> appointments = await _databaseHelper.getRecords(table: 'APPOINTMENT');
    return appointments.map((appointment) => Appointment.fromMap(appointment)).toList();
  }
}

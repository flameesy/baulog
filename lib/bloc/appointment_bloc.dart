import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/appointment_model.dart';
import '../core/services/appointment_service.dart';

class AppointmentEvent {}

class FetchAppointmentsEvent extends AppointmentEvent {
  final DateTime selectedDate;

  FetchAppointmentsEvent({required this.selectedDate});
}


class AppointmentsState {
  final List<Appointment> appointments;
  final Map<DateTime, List<Appointment>> appointmentsByDate;

  AppointmentsState({this.appointments = const [], this.appointmentsByDate = const {}});
}

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentsState> {
  final AppointmentService _appointmentService;

  AppointmentBloc(this._appointmentService) : super(AppointmentsState());

  Stream<AppointmentsState> mapEventToState(AppointmentEvent event) async* {
    if (event is FetchAppointmentsEvent) {
      final appointments = await _appointmentService.fetchAppointments();
      yield AppointmentsState(
        appointments: appointments,
        appointmentsByDate: _groupAppointmentsByDate(appointments),
      );
    }
  }

  Map<DateTime, List<Appointment>> _groupAppointmentsByDate(List<Appointment> appointments) {
    final Map<DateTime, List<Appointment>> appointmentsByDate = {};
    for (var appointment in appointments) {
      if (!appointmentsByDate.containsKey(appointment.appointmentDate)) {
        appointmentsByDate[appointment.appointmentDate] = [];
      }
      appointmentsByDate[appointment.appointmentDate]!.add(appointment);
    }
    return appointmentsByDate;
  }
}

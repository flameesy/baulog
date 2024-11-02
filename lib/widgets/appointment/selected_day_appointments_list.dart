import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/appointment_bloc.dart';
import '../../core/models/appointment_model.dart';
import '../../screens/appointments/appointment_detail.dart';

class SelectedDayAppointmentsList extends StatefulWidget {
  final List<Appointment> appointments; // Change to List<Appointment>
  final DateTime selectedDate;

  const SelectedDayAppointmentsList({
    Key? key,
    required this.appointments,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _SelectedDayAppointmentsListState createState() => _SelectedDayAppointmentsListState();
}

class _SelectedDayAppointmentsListState extends State<SelectedDayAppointmentsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.appointments.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.appointments.length) {
          return ListTile(
            title: Text(
              'Neuen Termin hinzufügen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () async {
              final result = await navigateToNewAppointmentDetailPage(context, const {});
              if (result != null) {
                BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentsEvent(selectedDate: widget.selectedDate)); // Trigger an event to fetch appointments
              }
            },
          );
        } else {
          final appointment = widget.appointments[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                appointment.text, // Directly use the property
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Startzeit: ${appointment.startTime.isNotEmpty ? formatTime(appointment.startTime) : 'Keine Startzeit verfügbar'} | Endzeit: ${appointment.endTime.isNotEmpty ? formatTime(appointment.endTime) : 'Keine Endzeit verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Beschreibung: ${appointment.description.isNotEmpty ? appointment.description : 'Keine Beschreibung verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Datum: ${_formatDate(appointment.appointmentDate) ?? 'Kein Datum verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Raum ID: ${appointment.roomId ?? 'Keine Raum ID verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              onTap: () async {
                final result = await navigateToAppointmentDetailPage(context, appointment);
                if (result != null) {
                  BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentsEvent(selectedDate: widget.selectedDate)); // Trigger an event to fetch appointments
                }
              },
            ),
          );
        }
      },
    );
  }

  Future<dynamic> navigateToNewAppointmentDetailPage(BuildContext context, Map<String, dynamic> appointment) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailPage(appointmentId: appointment['id']),
      ),
    );
  }

  Future<dynamic> navigateToAppointmentDetailPage(BuildContext context, Appointment appointment) { // Change to Appointment
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailPage(appointmentId: appointment.id), // Pass the id from Appointment
      ),
    );
  }
}

String formatTime(String time) {
  if (time.isEmpty) {
    return 'Keine Zeit verfügbar';
  }

  List<String> timeParts = time.split(':');
  if (timeParts.length < 2) {
    return 'Ungültige Zeit';
  }

  int? hours = int.tryParse(timeParts[0]);
  int? minutes = int.tryParse(timeParts[1]);

  if (hours == null || minutes == null) {
    return time;
  }

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

String _formatDate(DateTime date) {
  return DateFormat('dd.MM.yyyy').format(date);
}

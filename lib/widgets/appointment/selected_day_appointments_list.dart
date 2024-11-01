import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/appointment_bloc.dart';
import '../../screens/appointments/appointment_detail.dart';

class SelectedDayAppointmentsList extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;

  const SelectedDayAppointmentsList({
    Key? key,
    required this.appointments,
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
                BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentsEvent()); // Trigger an event to fetch appointments
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
                appointment['text'] ?? 'Kein Text verfügbar',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Startzeit: ${appointment['start_time'] != null ? formatTime(appointment['start_time']) : 'Keine Startzeit verfügbar'} | Endzeit: ${appointment['end_time'] != null ? formatTime(appointment['end_time']) : 'Keine Endzeit verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Beschreibung: ${appointment['description'] ?? 'Keine Beschreibung verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Datum: ${_formatDate(appointment['appointment_date']) ?? 'Kein Datum verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Raum ID: ${appointment['room_id'] ?? 'Keine Raum ID verfügbar'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              onTap: () async {
                final result = await navigateToAppointmentDetailPage(context, appointment);
                if (result != null) {
                  BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentsEvent()); // Trigger an event to fetch appointments
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

  Future<dynamic> navigateToAppointmentDetailPage(BuildContext context, Map<String, dynamic> appointment) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailPage(appointmentId: appointment['id']),
      ),
    );
  }
}

String formatTime(dynamic time) {
  if (time == null) {
    return 'Keine Zeit verfügbar';
  }

  if (time is DateTime) {
    return DateFormat('HH:mm').format(time);
  } else if (time is String) {
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

  return 'Ungültiges Format';
}

String _formatDate(dynamic date) {
  if (date == null) {
    return DateFormat('dd.MM.yyyy').format(DateTime.now());
  } else if (date is String) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd.MM.yyyy').format(parsedDate);
    } catch (e) {
      return DateFormat('dd.MM.yyyy').format(DateTime.now());
    }
  } else if (date is DateTime) {
    return DateFormat('dd.MM.yyyy').format(date);
  } else {
    return DateFormat('dd.MM.yyyy').format(DateTime.now());
  }
}

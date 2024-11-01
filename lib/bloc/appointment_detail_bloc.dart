import 'package:baulog/core/services/service_base.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

// Definiere die Events
abstract class AppointmentDetailEvent extends Equatable {
  const AppointmentDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointmentEvent extends AppointmentDetailEvent {
  final int appointmentId;

  const LoadAppointmentEvent(this.appointmentId);
}

class UpdateAppointmentEvent extends AppointmentDetailEvent {
  final Map<String, dynamic> appointmentData;

  const UpdateAppointmentEvent(this.appointmentData);
}

class AttachFileEvent extends AppointmentDetailEvent {
  final PlatformFile file;

  const AttachFileEvent(this.file);
}

class DeleteAttachmentEvent extends AppointmentDetailEvent {
  final String fileName;

  const DeleteAttachmentEvent(this.fileName);
}

// Definiere die States
abstract class AppointmentDetailState extends Equatable {
  const AppointmentDetailState();

  @override
  List<Object?> get props => [];
}

class AppointmentDetailLoading extends AppointmentDetailState {}

class AppointmentDetailLoaded extends AppointmentDetailState {
  final Map<String, dynamic> appointment;
  final List<PlatformFile> attachmentFiles;

  const AppointmentDetailLoaded(this.appointment, this.attachmentFiles);
}

class AppointmentDetailError extends AppointmentDetailState {
  final String message;

  const AppointmentDetailError(this.message);
}

class AppointmentDetailBloc extends Bloc<AppointmentDetailEvent, AppointmentDetailState> {
  final ServiceBase databaseHelper;

  AppointmentDetailBloc(this.databaseHelper)
      : super(AppointmentDetailLoading());

  @override
  Stream<AppointmentDetailState> mapEventToState(
      AppointmentDetailEvent event) async* {
    if (event is LoadAppointmentEvent) {
      yield AppointmentDetailLoading();
      try {
        // Hole das Appointment mit der gegebenen ID
        final appointmentRecords = await databaseHelper.getRecords(
          table: 'APPOINTMENT',
          where: 'id = ?', // Hier ist die ID des Termins
          whereArgs: [event.appointmentId],
        );

        if (appointmentRecords.isNotEmpty) {
          // Stelle sicher, dass appointmentRecords ein Map ist
          final appointment = appointmentRecords.first;

          // Hole die Anhänge für das Appointment
          final attachmentFiles = await databaseHelper.getRecords(
            table: 'attachment',
            where: 'appointment_id = ?',
            whereArgs: [appointment['id']], // Hier die korrekte ID verwenden
          );

          yield AppointmentDetailLoaded(
              appointment, attachmentFiles.cast<PlatformFile>());
        } else {
          yield AppointmentDetailError('Appointment not found');
        }
      } catch (error) {
        yield AppointmentDetailError(error.toString());
      }
    } else if (event is UpdateAppointmentEvent) {
      try {
        // Hier die updateRecord-Funktion verwenden
        await databaseHelper.updateRecord(
          table: 'APPOINTMENT',
          fields: 'text, appointment_date, start_time, end_time, description, participant_ids, platform_id, room_id, building_id',
          values: [
            event.appointmentData['text'],
            event.appointmentData['appointment_date'],
            event.appointmentData['start_time'],
            event.appointmentData['end_time'],
            event.appointmentData['description'],
            event.appointmentData['participant_ids'],
            event.appointmentData['platform_id'],
            event.appointmentData['room_id'],
            event.appointmentData['building_id'],
          ],
          where: 'id = ?',
          whereArgs: [event.appointmentData['appointment_id']],
        );
        // Hier könnte man die geladenen Daten erneut abrufen oder eine andere Logik implementieren
      } catch (error) {
        yield AppointmentDetailError(error.toString());
      }
    } else if (event is AttachFileEvent) {
      /*try {
        await databaseHelper.saveAttachmentForAppointment(event.file);
      } catch (error) {
        yield AppointmentDetailError(error.toString());
      }
    } else if (event is DeleteAttachmentEvent) {
      try {
        await databaseHelper.deleteAttachmentForAppointment(event.fileName);
      } catch (error) {
        yield AppointmentDetailError(error.toString());
      }
    }
    */
    }
  }
}
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/appointment_detail_bloc.dart'; // Importiere den BLoC
import 'package:baulog/core/services/service_base.dart';

class AppointmentDetailPage extends StatefulWidget {
  final int appointmentId;

  const AppointmentDetailPage({
    Key? key,
    required this.appointmentId,
  }) : super(key: key);

  @override
  _AppointmentDetailPageState createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  late final ServiceBase databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = ServiceBase(); // Hier initialisieren Sie die Datenbank oder den Dienst
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentDetailBloc(databaseHelper)..add(LoadAppointmentEvent(widget.appointmentId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Termin Details'),
        ),
        body: BlocBuilder<AppointmentDetailBloc, AppointmentDetailState>(
          builder: (context, state) {
            if (state is AppointmentDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AppointmentDetailLoaded) {
              return _buildDetailForm(context, state.appointment, state.attachmentFiles);
            } else if (state is AppointmentDetailError) {
              return Center(child: Text('Fehler: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailForm(BuildContext context, Map<String, dynamic> appointment, List<PlatformFile> attachmentFiles) {
    TextEditingController _textEditingController = TextEditingController(text: appointment['text']);
    TextEditingController _dateEditingController = TextEditingController(text: _formatDate(appointment['appointment_date']));
    TextEditingController _startTimeEditingController = TextEditingController(text: appointment['start_time']);
    TextEditingController _endTimeEditingController = TextEditingController(text: appointment['end_time']);
    TextEditingController _descriptionEditingController = TextEditingController(text: appointment['description']);
    TextEditingController _participantIdsEditingController = TextEditingController(text: appointment['participant_ids']);
    TextEditingController _platformIdEditingController = TextEditingController(text: appointment['platform_id']?.toString());
    TextEditingController _roomIdEditingController = TextEditingController(text: appointment['room_id']?.toString());
    TextEditingController _buildingIdEditingController = TextEditingController(text: appointment['building_id']?.toString());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appointment['id'] != null) ...[
              Text('ID: ${appointment['id']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
            ],
            _buildTextField('Text', _textEditingController),
            const SizedBox(height: 10),
            _buildDateField(context, _dateEditingController),
            const SizedBox(height: 10),
            _buildTimeFields(context, _startTimeEditingController, _endTimeEditingController),
            const SizedBox(height: 10),
            _buildTextField('Beschreibung', _descriptionEditingController),
            const SizedBox(height: 10),
            _buildTextField('Teilnehmer IDs', _participantIdsEditingController),
            const SizedBox(height: 10),
            _buildPlatformAndRoomFields(_platformIdEditingController, _roomIdEditingController),
            const SizedBox(height: 10),
            _buildTextField('Gebäude ID', _buildingIdEditingController, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildAttachmentList(context, attachmentFiles),
            const SizedBox(height: 10),
            _buildActionButtons(context, _textEditingController, _dateEditingController, _startTimeEditingController, _endTimeEditingController, _descriptionEditingController, _participantIdsEditingController, _platformIdEditingController, _roomIdEditingController, _buildingIdEditingController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  Widget _buildDateField(BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      decoration: const InputDecoration(labelText: 'Datum (TT.MM.JJJJ)', border: OutlineInputBorder()),
    );
  }

  Widget _buildTimeFields(BuildContext context, TextEditingController startController, TextEditingController endController) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: startController,
            readOnly: true,
            onTap: () => _selectTime(context, startController),
            decoration: const InputDecoration(labelText: 'Startzeit', border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: endController,
            readOnly: true,
            onTap: () => _selectTime(context, endController),
            decoration: const InputDecoration(labelText: 'Endzeit', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformAndRoomFields(TextEditingController platformController, TextEditingController roomController) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: platformController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Platform ID', border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: roomController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Raum ID', border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentList(BuildContext context, List<PlatformFile> attachmentFiles) {
    if (attachmentFiles.isEmpty) {
      return const Text('Keine Dateien angehängt');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: attachmentFiles.map((file) {
          return ListTile(
            title: Text(file.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<AppointmentDetailBloc>().add(DeleteAttachmentEvent(file.name));
              },
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, TextEditingController textController, TextEditingController dateController, TextEditingController startController, TextEditingController endController, TextEditingController descriptionController, TextEditingController participantIdsController, TextEditingController platformIdController, TextEditingController roomIdController, TextEditingController buildingIdController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Map<String, dynamic> appointmentData = {
              'text': textController.text,
              'appointment_date': DateFormat('yyyy-MM-dd').format(DateTime.parse(dateController.text)),
              'start_time': startController.text,
              'end_time': endController.text,
              'description': descriptionController.text,
              'participant_ids': participantIdsController.text,
              'platform_id': int.tryParse(platformIdController.text),
              'room_id': int.tryParse(roomIdController.text),
              'building_id': int.tryParse(buildingIdController.text),
            };
            context.read<AppointmentDetailBloc>().add(UpdateAppointmentEvent(appointmentData));
          },
          child: const Text('Speichern'),
        ),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              for (var file in result.files) {
                context.read<AppointmentDetailBloc>().add(AttachFileEvent(file));
              }
            }
          },
          child: const Text('Datei anhängen'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('dd.MM.yyyy').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  }
}

class Appointment {
  final int id;
  final int roomId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String text;
  final String description;

  Appointment({
    required this.id,
    required this.roomId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.text,
    required this.description,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      roomId: map['room_id'],
      appointmentDate: DateTime.parse(map['appointment_date']),
      startTime: map['start_time'],
      endTime: map['end_time'],
      text: map['text'],
      description: map['description'],
    );
  }

}

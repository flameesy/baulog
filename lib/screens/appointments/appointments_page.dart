import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/appointment_bloc.dart';
import '../../widgets/common/appBar/custom_app_bar.dart';
import '../../widgets/appointment/selected_day_appointments_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  DateTime selectedDay = DateTime.now(); // Store the selected day

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 400, // Set the height of the calendar
              child: CalendarCarousel(
                onDayPressed: (DateTime date, List<dynamic> events) {
                  setState(() {
                    selectedDay = date; // Update the selected day
                  });
                  // Fetch appointments for the selected day
                  BlocProvider.of<AppointmentBloc>(context).add(FetchAppointmentsEvent());
                },
                thisMonthDayBorderColor: Colors.grey,
                selectedDateTime: selectedDay,
                locale: 'de',
                customDayBuilder: (bool isSelectable, int index, bool isSelectedDay, bool isToday, bool isPrevMonthDay, TextStyle textStyle, bool isNextMonthDay, bool isThisMonthDay, DateTime day) {
                  final hasAppointments = state.appointmentsByDate.containsKey(day);
                  return _buildCalendarDay(day, textStyle, hasAppointments, isToday, isSelectedDay, state);
                },
              ),
            ),
            Expanded(
              child: SelectedDayAppointmentsList(
                appointments: (state.appointmentsByDate[selectedDay] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList() ?? [],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarDay(DateTime day, TextStyle textStyle, bool hasAppointments, bool isToday, bool isSelectedDay, AppointmentsState state) {
    Color dayColor = isToday && !isSelectedDay ? Colors.orange : textStyle.color!;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: hasAppointments ? Colors.transparent : Colors.transparent),
      ),
      child: Stack(
        children: [
          Center(child: Text('${day.day}', style: textStyle.copyWith(color: dayColor))),
          if (hasAppointments)
            Positioned(
              bottom: 2,
              right: 2,
              child: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                radius: 8,
                child: Text('${(state.appointmentsByDate[day]?.length ?? 0)}', style: const TextStyle(fontSize: 10, color: Colors.black)),
              ),
            ),
        ],
      ),
    );
  }
}

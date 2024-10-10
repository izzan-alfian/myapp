import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/widgets/attendance_item.dart';

class AttendancesBackdate extends StatefulWidget {
  @override
  _AttendancesBackdateState createState() => _AttendancesBackdateState();
}

class _AttendancesBackdateState extends State<AttendancesBackdate> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back Date', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF33499e),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(20.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) async {
                // Pilih waktu setelah memilih tanggal
                TimeOfDay? selectedTime = await _selectTime(context);
                if (selectedTime != null) {
                  setState(() {
                    // Gabungkan tanggal dan waktu ke dalam DateTime
                    _selectedDay = DateTime(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    _focusedDay = focusedDay;
                  });

                  print("Selected Date and Time: $_selectedDay"); // Debugging log
                  context.read<AttendancesBloc>().add(FetchAttendanceByDate(date: _selectedDay!));
                }
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onHeaderTapped: (_) => _showYearPicker(context),
            ),
          ),
          Expanded(
            child: BlocBuilder<AttendancesBloc, AttendancesState>(
              builder: (context, state) {
                if (state is AttendanceLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is AttendanceLoaded) {
                  return ListView.builder(
                    itemCount: state.attendances.length,
                    itemBuilder: (context, index) {
                      return AttendanceItem(attendance: state.attendances[index]);
                    },
                  );
                } else if (state is AttendanceError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('Select a date to view attendances'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return selectedTime;
  }

  void _showYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Year"),
          content: Container(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime(DateTime.now().year + 100, 1),
              initialDate: DateTime.now(),
              selectedDate: _focusedDay,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _focusedDay = DateTime(dateTime.year, _focusedDay.month, _focusedDay.day);
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}




class AttendanceItem extends StatelessWidget {
  final Attendance attendance;

  AttendanceItem({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendancesBloc, AttendancesState>(
      builder: (context, state) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendance.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4), // Jarak kecil antara nama dan posisi
                  Text(attendance.position),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (attendance.checkIn != null)
                    Text(
                      "Checked In: ${_formatDateTime(attendance.checkIn!)}",
                      style: TextStyle(fontSize: 12,  fontWeight: FontWeight.bold, backgroundColor: Colors.white),
                    ),
                  if (attendance.checkOut != null)
                    Text(
                      "Checked Out: ${_formatDateTime(attendance.checkOut!)}",
                      style: TextStyle(fontSize: 12,  fontWeight: FontWeight.bold, backgroundColor: Colors.white),
                    ),
                ],
              ),


            ],),

            trailing: GestureDetector(
              onTap: () {
                  if (attendance.checkIn == null || (attendance.checkOut != null && attendance.checkIn!.isBefore(attendance.checkOut!))) {
                    _showCheckInConfirmation(context);
                  } else {
                    _showCheckOutConfirmation(context);
                  }
                },

              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getIconColor(),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  _getIcon(),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

 IconData _getIcon() {
  if (attendance.checkIn == null) {
    return Icons.circle_outlined;
  } else if (attendance.checkOut == null || (attendance.checkOut != null && attendance.checkIn!.isAfter(attendance.checkOut!))) {
    return Icons.access_time;
  } else {
    return Icons.check_circle_outline;
  }
}


  Color _getIconColor() {
  if (attendance.checkIn == null) {
    return Colors.red;
  } else if (attendance.checkOut == null || (attendance.checkOut != null && attendance.checkIn!.isAfter(attendance.checkOut!))) {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}


  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  }

  void _showCheckInConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Check-In Confirmation'),
          content: Text('Are you sure you want to check in?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                context.read<AttendancesBloc>().add(UpdateAttendanceStatus(attendance.name, isCheckIn: true));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCheckOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Check-Out Confirmation'),
          content: Text('Are you sure you want to check out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                context.read<AttendancesBloc>().add(UpdateAttendanceStatus(attendance.name, isCheckIn: false));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCheckInAgainConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Check-In Again Confirmation'),
          content: Text('Are you sure you want to check in again?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                context.read<AttendancesBloc>().add(UpdateAttendanceStatus(attendance.name, isCheckIn: true));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
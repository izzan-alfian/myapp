import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/widgets/attendance_item.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

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
                if (isSameDay(selectedDay, DateTime.now())) {
                  // Jika hari ini, langsung gunakan tanggal tanpa memilih waktu
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  // Menampilkan data dari halaman attendances.dart (hari ini)
                    context.read<AttendancesBloc>().add(FetchAttendance(date: DateTime.now()));

                } else {
                  // Jika bukan hari ini, tampilkan pemilih waktu
                  TimeOfDay? selectedTime = await _selectTime(context);
                  if (selectedTime != null) {
                    setState(() {
                      _selectedDay = DateTime(
                        selectedDay.year,
                        selectedDay.month,
                        selectedDay.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      _focusedDay = focusedDay;
                    });

                    // Kirimkan tanggal yang dipilih kembali ke halaman sebelumnya
                    print("Selected Date and Time: $_selectedDay"); // Debugging log
                    context.read<AttendancesBloc>().add(FetchAttendanceByDate(date: _selectedDay!));
                  }
                }
                  // Navigator.pop(context, _selectedDay);
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
                Navigator.pop(context, _selectedDay);
              },
            ),
          ),
        );
      },
    );
  }
}


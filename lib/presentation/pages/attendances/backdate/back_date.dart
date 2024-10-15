import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';



class BackDate extends StatefulWidget {
  @override
  _BackDateState createState() => _BackDateState();
}

class _BackDateState extends State<BackDate> {
DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;
CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf0f0f0),
      appBar: AppBar(
        backgroundColor: Color(0xFF33499e),
        title: Text('Back Date', style: TextStyle(color: Colors.white)),
      ),
    
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(6.0),
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
                 (selectedTime) {
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
                    // context.read<AttendancesBloc>().add(FetchAttendanceByDate(date: _selectedDay!));
                  };
                }
                  Navigator.pop(context, _selectedDay);
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
              // onHeaderTapped: (_) => _showYearPicker(context),
            ),
          ),
        ]
      ),
    );
  }
}

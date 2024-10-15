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
                  } else {
                    // Jika hari lain, tampilkan time picker
                    final selectedTime = await _selectTime(context);
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
                    }
                  }

                  // Kirimkan tanggal yang dipilih kembali ke halaman sebelumnya
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

 Future<TimeOfDay?> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return selectedTime;
  }

  // void _showYearPicker(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Select Year"),
  //         content: Container(
  //           width: 300,
  //           height: 300,
  //           child: YearPicker(
  //             firstDate: DateTime(DateTime.now().year - 100, 1),
  //             lastDate: DateTime(DateTime.now().year + 100, 1),
  //             initialDate: DateTime.now(),
  //             selectedDate: _focusedDay,
  //             onChanged: (DateTime dateTime) {
  //               setState(() {
  //                 _focusedDay = DateTime(dateTime.year, _focusedDay.month, _focusedDay.day);
  //               });
  //               Navigator.pop(context, _selectedDay);
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


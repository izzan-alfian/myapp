import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_event.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_state.dart';
import 'package:myapp/presentation/widgets/backdate_item.dart';
import 'package:table_calendar/table_calendar.dart';

class BackDateAttPage extends StatefulWidget {
  @override
  _BackDatePageState createState() => _BackDatePageState();
}

class _BackDatePageState extends State<BackDateAttPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BackdateBloc()..add(FetchBackdate(date: DateTime.now())),

      child: Scaffold(
        appBar: AppBar(
          title: Text('Back Date', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF33499e),
        //     actions: [
        //   IconButton(
        //     icon: Icon(Icons.search, color: Colors.white),
        //     onPressed: () {
        //       // Menggunakan showSearch untuk menampilkan search bar
        //       showSearch(
        //         context: context,
        //         delegate: BackdateSearchDelegate(),
        //       );
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.filter_list, color: Colors.white),
        //     onPressed: () {
        //       showMenu(
        //         context: context,
        //         position: RelativeRect.fromLTRB(
        //             100, 80, 0, 0), // Sesuaikan posisi popup
        //         items: [
        //           PopupMenuItem(
        //             child: ListTile(
        //               leading: Icon(Icons.circle_outlined),
        //               title: Text('Non-checked'),
        //               onTap: () {
        //                 setState(() {
        //                   backdateFilter = 'Non-checked';
        //                 });
        //                 // Logika untuk filter 'Non-checked'
        //                 _filterAndReloadBackdate();
        //                 Navigator.pop(context); // Menutup popup setelah memilih
        //               },
        //             ),
        //           ),
        //           PopupMenuItem(
        //             child: ListTile(
        //               leading: Icon(Icons.access_time),
        //               title: Text('Checked in'),
        //               onTap: () {
        //                 setState(() {
        //                   backdateFilter = 'Checked in';
        //                 });
        //                 // Logika untuk filter 'Checked in'
        //                 _filterAndReloadBackdate();
        //                 Navigator.pop(context); // Menutup popup setelah memilih
        //               },
        //             ),
        //           ),
        //           PopupMenuItem(
        //             child: ListTile(
        //               leading: Icon(Icons.check_circle_outline),
        //               title: Text('Checked out'),
        //               onTap: () {
        //                 setState(() {
        //                   backdateFilter = 'Checked out';
        //                 });
        //                 // Logika untuk filter 'Checked out'
        //                 _filterAndReloadBackdate();
        //                 Navigator.pop(context); // Menutup popup setelah memilih
        //               },
        //             ),
        //           ),
        //         ],
        //       );
        //     },
        //   ),
        //     IconButton(
        //     icon: Icon(Icons.calendar_today, color: Colors.white),
        //     onPressed: () { Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => BackDateAttPage()),          
        //       );
        //     },
        //   ),
        // ],
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(12.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) async {
                  // Jika hari ini, gunakan tanggal langsung
                  if (isSameDay(selectedDay, DateTime.now())) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    context.read<BackdateBloc>().add(FetchBackdate(date: DateTime.now()));
                  } else {
                    // Jika hari berbeda, tampilkan pemilih waktu
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

                      context.read<BackdateBloc>().add(FetchBackdate(date: _selectedDay!));
                    }
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
              child: BlocBuilder<BackdateBloc, BackdateState>(
                builder: (context, state) {
                  if (state is BackDateLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is BackdateLoaded) {
                    if (state.allBackDate.isEmpty) {
                      return Center(child: Text('No data for the selected date.'));
                    }
                    return ListView.builder(
                      itemCount: state.allBackDate.length,
                      itemBuilder: (context, index) {
                        return BackdateItem(backdate: state.allBackDate[index]);
                      },
                    );
                  } else if (state is BackdateError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text('Select a date to view attendances.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
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

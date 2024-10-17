import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/back_date_model.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_event.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_state.dart';
import 'package:myapp/presentation/widgets/backdate/backdate_item.dart';
import 'package:myapp/presentation/widgets/backdate/backdate_searchbar.dart';
import 'package:table_calendar/table_calendar.dart';

class BackDateAttPage extends StatefulWidget {
  @override
  _BackDatePageState createState() => _BackDatePageState();
}

class _BackDatePageState extends State<BackDateAttPage> {
  String backdateFilter = 'All';

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _isCalendarExpanded = false; // Flag untuk ekspansi kalender

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BackdateBloc()..add(FetchBackdate(date: DateTime.now())),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF33499e),
          title: Text('Back Date', style: TextStyle(color: Colors.white)),
          leading: backdateFilter != 'All'
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      backdateFilter = 'All';
                    });
                    _filterAndReloadBackdate(context); // Melewatkan context
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Menggunakan showSearch untuk menampilkan search bar
                showSearch(
                  context: context,
                  delegate: BackdateSearchDelegate(),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 80, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.circle_outlined),
                        title: Text('Non-checked'),
                        onTap: () {
                          setState(() {
                            backdateFilter = 'Non-checked';
                          });
                          _filterAndReloadBackdate(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text('Checked in'),
                        onTap: () {
                          setState(() {
                            backdateFilter = 'Checked in';
                          });
                          _filterAndReloadBackdate(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Checked out'),
                        onTap: () {
                          setState(() {
                            backdateFilter = 'Checked out';
                          });
                          _filterAndReloadBackdate(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
                  ),
            body: Column(
                  children: [
                    // Gunakan Card untuk membungkus header tanggal
                    Card(
                      elevation: 4, // Memberikan bayangan pada Card
                      margin: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: _isCalendarExpanded,
                        title: Text(
                          DateFormat('MMMM yyyy').format(_focusedDay), // Format bulan-tahun
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          _isCalendarExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color:  Color(0xFF33499e),
                        ),
                        onExpansionChanged: (isExpanded) {
                          setState(() {
                            _isCalendarExpanded = isExpanded;
                          });
                        },
                        children: [
                          TableCalendar(
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

                                    context.read<BackdateBloc>().add(
                                      UpdateBackdateWithDateTime(
                                        selectedDateTime: _selectedDay!,
                                      ),
                                    );
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
                             ],
                            ),
                          ),
                    
            Expanded(
              child: BlocBuilder<BackdateBloc, BackdateState>(
                builder: (context, state) {
                   print("Bloc State: $state"); 
                  if (state is BackDateLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is BackdateLoaded) {
                    final filteredBackdate =
                        _filterBackdate(state.allBackDate, backdateFilter);
                    if (filteredBackdate.isEmpty) {
                      return Center(
                        child: Text(
                          'No backdate found for the selected filter $backdateFilter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[600]),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: filteredBackdate.length,
                      itemBuilder: (context, index) {
                        return BackdateItem(
                            backdate: filteredBackdate[index]);
                      },
                    );
                  } else if (state is BackdateError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Center(
                      child: Text("No data available"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterAndReloadBackdate(BuildContext context) {
    BlocProvider.of<BackdateBloc>(context)
        .add(FilterBackdateEvent(backdateFilter));
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
                  _focusedDay = DateTime(dateTime.year, _focusedDay.month,
                      _focusedDay.day);
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  List<BackDate> _filterBackdate(List<BackDate> backdate, String filter) {
    final filtered = backdate.where((backdate) {
      final isCheckedIn = backdate.checkIn != null;
      final isCheckedOut = backdate.checkOut != null;

      if (filter == 'Non-checked') {
        return !isCheckedIn;
      } else if (filter == 'Checked in') {
        if (isCheckedIn &&
            (!isCheckedOut || backdate.checkIn!.isAfter(backdate.checkOut!))) {
          return true;
        }
        return false;
      } else if (filter == 'Checked out') {
        return isCheckedIn &&
            isCheckedOut &&
            backdate.checkIn!.isBefore(backdate.checkOut!);
      } else {
        return true;
      }
    }).toList();

      print("Total backdate after filter: ${filtered.length}");
    return filtered;
  }
}


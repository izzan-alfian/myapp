
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/pages/attendances/attendances_backdate.dart';

class AttendancesPage extends StatefulWidget {
  @override
  _AttendancesPageState createState() => _AttendancesPageState();
}

class _AttendancesPageState extends State<AttendancesPage> {
  String attendanceFilter = 'All';

  @override
  Widget build(BuildContext context) {
      // Get current date
    DateTime now = DateTime.now();
    // Format date as "Day, DD Month YYYY"
    String formattedDate = DateFormat('d MMMM yyyy').format(now);
    String dayOfWeek = DateFormat('EEEE').format(now);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF33499e),
        title: Text('Attendances', style: TextStyle(color: Colors.white)),
         leading: attendanceFilter != 'All'
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    attendanceFilter = 'All';
                  });
                  _filterAndReloadAttendances();
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
                delegate: AttendanceSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    100, 80, 0, 0), // Sesuaikan posisi popup
                items: [
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.circle_outlined),
                      title: Text('Non-checked'),
                      onTap: () {
                        setState(() {
                          attendanceFilter = 'Non-checked';
                        });
                        // Logika untuk filter 'Non-checked'
                        _filterAndReloadAttendances();
                        Navigator.pop(context); // Menutup popup setelah memilih
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Checked in'),
                      onTap: () {
                        setState(() {
                          attendanceFilter = 'Checked in';
                        });
                        // Logika untuk filter 'Checked in'
                        _filterAndReloadAttendances();
                        Navigator.pop(context); // Menutup popup setelah memilih
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.check_circle_outline),
                      title: Text('Checked out'),
                      onTap: () {
                        setState(() {
                          attendanceFilter = 'Checked out';
                        });
                        // Logika untuk filter 'Checked out'
                        _filterAndReloadAttendances();
                        Navigator.pop(context); // Menutup popup setelah memilih
                      },
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Bagian untuk menampilkan tanggal
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Color(0xFF33499e)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttendancesBackdate()),
                    );
                  },
                ),
                SizedBox(width: 6),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4), // Spasi antara "Today" dan tanggal
                    Text(
                     '$dayOfWeek, $formattedDate',  // Dynamic Date
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bagian untuk menampilkan attendance
          Expanded(
            child: BlocBuilder<AttendancesBloc, AttendancesState>(
              builder: (context, state) {
                 print("Bloc State: $state"); 
                if (state is AttendanceLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AttendanceLoaded) {
                  final filteredAttendances = _filterAttendances(state.attendances, attendanceFilter);
                  if (filteredAttendances.isEmpty) {
                    return Center(
                      child: Text(
                        'No attendances found for the selected filter $attendanceFilter',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredAttendances.length,
                    itemBuilder: (context, index) {
                      return AttendanceItem(attendance: filteredAttendances[index]);
                    },
                  );
                } else if (state is AttendanceError) {
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
    );
  }

void _filterAndReloadAttendances() {
  // Ensure the correct filter event is being dispatched to the bloc
  BlocProvider.of<AttendancesBloc>(context)
      .add(FilterAttendancesEvent(attendanceFilter));
}

}

List<Attendance> _filterAttendances(List<Attendance> attendances, String filter) {
  print("Applying filter: $filter");
  print("Total attendances before filter: ${attendances.length}");
  
  final filtered = attendances.where((attendance) {
    final isCheckedIn = attendance.checkIn != null;
    final isCheckedOut = attendance.checkOut != null;

    if (filter == 'Non-checked') {
      return !isCheckedIn && !isCheckedOut;
    } else if (filter == 'Checked in') {
      return isCheckedIn && !isCheckedOut;
    } else if (filter == 'Checked out') {
      return isCheckedIn && isCheckedOut;
    } else {
      return true; // Show all
    }
  }).toList();

  print("Total attendances after filter: ${filtered.length}");
  return filtered;
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


class AttendanceSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Menghapus input query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Menutup search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<AttendancesBloc, AttendancesState>(
      builder: (context, state) {
        if (state is AttendanceLoaded) {
          final results = state.attendances
              .where((attendance) =>
                  attendance.name.toLowerCase().contains(query.toLowerCase()) ||
                  attendance.position
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final attendance = results[index];
              return AttendanceItem(attendance: attendance);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<AttendancesBloc, AttendancesState>(
      builder: (context, state) {
        if (state is AttendanceLoaded) {
          final suggestions = state.attendances
              .where((attendance) =>
                  attendance.name.toLowerCase().contains(query.toLowerCase()) ||
                  attendance.position
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final attendance = suggestions[index];
              return ListTile(
                title: Text(attendance.name),
                subtitle: Text(attendance.position),
                onTap: () {
                  query = attendance.name; // Set query saat item di-tap
                  showResults(context); // Tampilkan hasil
                },
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

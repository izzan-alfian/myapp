
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/widgets/attendance_item.dart';
import 'package:myapp/presentation/widgets/attendances_backdate.dart';
import 'package:myapp/presentation/widgets/attendances_searchbar.dart';

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
                // IconButton(
                //   icon: Icon(Icons.calendar_today, color: Color(0xFF33499e)),
                //                     onPressed: () async {
                //       // Navigasi ke halaman AttendancesBackdate dan tunggu hasilnya
                //       DateTime? selectedDate = await Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => AttendancesBackdate(),
                //         ),
                //       //   ).then((_) {
                //       //   // Ketika kembali dari halaman AttendancesBackdate, fetch ulang data attendances
                //       //   context.read<AttendancesBloc>().add(FetchAttendance(date: DateTime.now()));
                //       // }
                //       );
                      
                //     if (selectedDate != null) {
                //       // Lakukan sesuatu dengan tanggal yang dipilih, misalnya memuat ulang data kehadiran berdasarkan tanggal
                //       context.read<AttendancesBloc>().add(FetchAttendanceByDate(date: selectedDate));
                //     }
                //   },
                // ),
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
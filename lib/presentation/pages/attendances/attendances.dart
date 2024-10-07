import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

class AttendancesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendancesBloc()
        ..add(FetchAttendance()), // Inisialisasi Bloc dan fetch data
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Attendances', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(Icons.search,color: Colors.white),
              onPressed: () {
                // Logic for search action
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                // Logic for filter action
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Bagian untuk menampilkan tanggal
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Today',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '25 October 2024',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            // Bagian untuk menampilkan attendance
            Expanded(
              child: BlocBuilder<AttendancesBloc, AttendancesState>(
                builder: (context, state) {
                  if (state is AttendanceLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    ); // Menampilkan loading ketika fetch data
                  } else if (state is AttendanceLoaded) {
                    return ListView.builder(
                      itemCount: state.attendances.length,
                      itemBuilder: (context, index) {
                        final attendance = state.attendances[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Text(attendance.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${attendance.position}"),
                                Text("${attendance.time}"),
                                // Text("Check-In: ${attendance.checkIn}"),
                                // Text("Check-Out: ${attendance.checkOut}"),
                              ],
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                              ),
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.access_time,
                                color: Colors.white,
                              ),
                            ),     
                          ),
                        );
                      },
                    );
                  } else if (state is AttendanceError) {
                    return Center(
                      child: Text(state.message),
                    ); // Menampilkan error jika terjadi kesalahan
                  } else {
                    return Center(
                      child: Text("No data available"),
                    ); // Menampilkan teks jika tidak ada data
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

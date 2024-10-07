import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

class AttendancesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendancesBloc()..add(FetchAttendance()), // Inisialisasi Bloc dan fetch data
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Attendances', style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
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
              padding: const EdgeInsets.all(16.0),
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
                        return AttendanceItem(attendance: attendance);
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

class AttendanceItem extends StatefulWidget {
  final dynamic attendance; // Sesuaikan tipe data attendance yang digunakan
  AttendanceItem({required this.attendance});

  @override
  _AttendanceItemState createState() => _AttendanceItemState();
}

class _AttendanceItemState extends State<AttendanceItem> {
  bool isCheckedIn = false;
  DateTime? checkInTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(widget.attendance.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.attendance.position}"),
            Text("${widget.attendance.time}"),
            if (isCheckedIn && checkInTime != null)
              Text("Checked In: ${checkInTime!.hour}:${checkInTime!.minute}"), // Menampilkan waktu check-in
          ],
        ),
        trailing: GestureDetector(
          onTap: () => _showCheckInConfirmation(context), // Menambahkan dialog konfirmasi
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCheckedIn ? Colors.blue : Colors.redAccent,
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.access_time,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showCheckInConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Check-In Confirmation'),
          content: Text('Are you sure you want to check in?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog tanpa melakukan apa-apa
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  isCheckedIn = true;
                  checkInTime = DateTime.now(); // Set waktu check-in
                });
                Navigator.of(context).pop(); // Menutup dialog setelah konfirmasi
              },
            ),
          ],
        );
      },
    );
  }
}

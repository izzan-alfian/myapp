import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';
import 'package:myapp/presentation/pages/attendances/attendances_backdate.dart';

class AttendancesPage extends StatefulWidget {
  @override
  _AttendancesPageState createState() => _AttendancesPageState();
}

class _AttendancesPageState extends State<AttendancesPage> {
  String attendanceFilter = 'All';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF33499e),
        title: Text('Attendances', style: TextStyle(color: Colors.white)),
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
                SizedBox(width: 2),
                Text(
                  'Today',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(width: 8),
                Text(
                  '8 October 2024',
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
                  final filteredAttendances = _filterAttendances(state.attendances, attendanceFilter);
                  return ListView.builder(
                    itemCount: filteredAttendances.length,
                    itemBuilder: (context, index) {
                      final attendance = filteredAttendances[index];
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
    );
  }
}

List<dynamic> _filterAttendances(List<dynamic> attendances, String filter) {
  if (filter == 'Non-checked') {
    print('Filter: Non-checked');
    // Menggunakan properti yang benar sesuai dengan model Attendance
    return attendances.where((attendance) => !attendance.checkIn && !attendance.checkOut).toList();
  } else if (filter == 'Checked in') {
     print('Filter: Checked in');
    return attendances.where((attendance) => attendance.checkIn && !attendance.checkOut).toList();
  } else if (filter == 'Checked out') {
    print('Filter: Checked out');
    return attendances.where((attendance) => attendance.checkOut).toList();
  } else {
    print('Filter: All');
    return attendances; // Jika tidak ada filter, tampilkan semua data
  }
}


// Buat AttendanceItem Widget seperti sebelumnya
class AttendanceItem extends StatefulWidget {
  final dynamic attendance; // Sesuaikan tipe data attendance yang digunakan
  AttendanceItem({required this.attendance});

  @override
  _AttendanceItemState createState() => _AttendanceItemState();
}

class _AttendanceItemState extends State<AttendanceItem> {
  bool isCheckedIn = false;
  bool isCheckedOut = false;
  DateTime? checkInTime;
  DateTime? checkOutTime;

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
            // Text("${widget.attendance.time}"),
            if (isCheckedIn && checkInTime != null)
              Text(
                  "Checked In: ${checkInTime!.hour}:${checkInTime!.minute}:${checkInTime!.second}"), // Menampilkan waktu check-in
            if (isCheckedOut && checkOutTime != null)
              Text(
                  "Checked Out: ${checkOutTime!.hour}:${checkOutTime!.minute}:${checkInTime!.second}"), // Menampilkan waktu check-out
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            if (!isCheckedIn) {
              _showCheckInConfirmation(context); // Konfirmasi untuk check-in
            } else if (isCheckedIn && !isCheckedOut) {
              _showCheckOutConfirmation(context); // Konfirmasi untuk check-out
            } else if (isCheckedIn && isCheckedOut) {
              _showCheckInAgainConfirmation(
                  context); // Konfirmasi untuk check-in kembali
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getIconColor(), // Warna ikon tergantung status
            ),
            padding: EdgeInsets.all(8),
            child: Icon(
              _getIcon(), // Ikon tergantung status
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mendapatkan ikon sesuai status
  IconData _getIcon() {
    if (!isCheckedIn) {
      return Icons.circle_outlined; // Ikon untuk check-in (jam)
    } else if (isCheckedIn && !isCheckedOut) {
      return Icons.access_time; // Ikon untuk check-out (ceklis bulat)
    } else if (isCheckedOut) {
      return Icons.check_circle_outline; // Ikon untuk check-in kembali
    } else {
      return Icons.done; // Ikon setelah selesai check-out
    }
  }

  // Fungsi untuk mendapatkan warna ikon sesuai status
  Color _getIconColor() {
    if (!isCheckedIn) {
      return Colors.redAccent; // Warna untuk check-in
    } else if (isCheckedIn && !isCheckedOut) {
      return Colors.blue; // Warna untuk check-out
    } else if (isCheckedOut) {
      return Colors.green; // Warna untuk check-in kembali
    } else {
      return Colors.grey; // Warna setelah selesai check-out
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi check-in
  void _showCheckInConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.white, // Mengubah warna background menjadi putih
          title: Text('Check-In Confirmation'),
          content: Text('Are you sure you want to check in?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Menutup dialog tanpa melakukan apa-apa
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  isCheckedIn = true;
                  checkInTime = DateTime.now(); // Set waktu check-in
                  isCheckedOut = false; // Reset status check-out
                });
                Navigator.of(context)
                    .pop(); // Menutup dialog setelah konfirmasi
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi check-out
  void _showCheckOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.white, // Mengubah warna background menjadi putih
          title: Text('Check-Out Confirmation'),
          content: Text('Are you sure you want to check out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Menutup dialog tanpa melakukan apa-apa
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  isCheckedOut = true;
                  checkOutTime = DateTime.now(); // Set waktu check-out
                });
                Navigator.of(context)
                    .pop(); // Menutup dialog setelah konfirmasi
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi check-in kembali
  void _showCheckInAgainConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.white, // Mengubah warna background menjadi putih
          title: Text('Check-In Again Confirmation'),
          content: Text('Are you sure you want to check in again?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Menutup dialog tanpa melakukan apa-apa
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  isCheckedIn = true;
                  checkInTime = DateTime.now(); // Set waktu check-in baru
                  isCheckedOut = false; // Reset status check-out
                });
                Navigator.of(context)
                    .pop(); // Menutup dialog setelah konfirmasi
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart'; // Sesuaikan dengan nama file Bloc Anda
import 'package:myapp/presentation/pages/attendances/attendances.dart'; // Sesuaikan dengan model Attendance Anda

class AttendanceItem extends StatelessWidget {
  final Attendance attendance;

  const AttendanceItem({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCheckedIn = attendance.checkInTime != null;
    bool isCheckedOut = attendance.checkOutTime != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(attendance.studentName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Check-in: ${attendance.checkInTime?.toLocal().toString() ?? 'Belum Check-in'}'),
            Text('Check-out: ${attendance.checkOutTime?.toLocal().toString() ?? 'Belum Check-out'}'),
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            if (!isCheckedIn) {
              _showCheckInConfirmation(context);
            } else if (isCheckedIn && !isCheckedOut) {
              _showCheckOutConfirmation(context);
            }
          },
          child: Icon(
            isCheckedOut ? Icons.check_circle : isCheckedIn ? Icons.check : Icons.circle,
            color: isCheckedOut ? Colors.green : (isCheckedIn ? Colors.blue : Colors.red),
          ),
        ),
      ),
    );
  }

  void _showCheckInConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Check-in'),
          content: const Text('Apakah Anda yakin ingin melakukan check-in?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<AttendancesBloc>().add(CheckInAttendance(attendance.id));
                Navigator.of(context).pop();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Check-out'),
          content: const Text('Apakah Anda yakin ingin melakukan check-out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<AttendancesBloc>().add(CheckOutAttendance(attendance.id));
                Navigator.of(context).pop();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}

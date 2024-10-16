import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';
import 'package:myapp/presentation/widgets/attendances/attendances_leaves.dart';

class AttendanceItem extends StatelessWidget {
  final Attendance attendance;

  const AttendanceItem({super.key, required this.attendance});

   @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendancesBloc, AttendancesState>(
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama yang dipotong jika terlalu panjang
                      Text(
                        attendance.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Membatasi hanya satu baris
                      ),
                      const SizedBox(height: 4),
                      // Posisi/role
                      Text(attendance.position),
                    ],
                  ),
                ),
               Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (attendance.checkIn != null)
                      Text(
                        "In: ${_formatDateTime(attendance.checkIn!)}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    if (attendance.checkOut != null)
                      Text(
                        "Out: ${_formatDateTime(attendance.checkOut!)}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                     
                  ],
                ),

              
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    if (attendance.checkIn == null ||
                        (attendance.checkOut != null && attendance.checkIn!.isBefore(attendance.checkOut!))) {
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
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      _getIcon(),
                      color: Colors.white,
                    ),
                  ),
                ),
  
              
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (String value) {
                    if (value == 'leaves') {
                      _navigateToLeavesForm(context);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'leaves',
                      child: Text('Leaves'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIcon() {
    if (attendance.checkIn == null) {
      return Icons.circle_outlined;
    } else if (attendance.checkOut == null ||
        (attendance.checkOut != null && attendance.checkIn!.isAfter(attendance.checkOut!))) {
      return Icons.access_time;
    } else {
      return Icons.check_circle_outline;
    }
  }

  Color _getIconColor() {
    if (attendance.checkIn == null) {
      return Colors.red;
    } else if (attendance.checkOut == null ||
        (attendance.checkOut != null && attendance.checkIn!.isAfter(attendance.checkOut!))) {
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
}


void _navigateToLeavesForm(BuildContext context) {
  // Navigasi ke halaman form leaves
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AttendancesLeaves()),
  );
}
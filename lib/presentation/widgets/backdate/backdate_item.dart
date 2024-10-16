import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/back_date_model.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_event.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_state.dart';
import 'package:myapp/presentation/widgets/backdate/backdate_leaves.dart';

class BackdateItem extends StatelessWidget {
  final BackDate backdate;

  const BackdateItem({super.key, required this.backdate});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BackdateBloc, BackdateState>(
        listener: (context, state) {
      if (state is BackdateUpdated) {
        // Handle any specific UI update or snackbars for feedback
      }
    }, child: BlocBuilder<BackdateBloc, BackdateState>(
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
                        backdate.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Membatasi hanya satu baris
                      ),
                      const SizedBox(height: 4),
                      // Posisi/role
                      Text(backdate.position),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (backdate.checkIn != null)
                      Text(
                        "In: ${_formatDateTime(backdate.checkIn!)}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    if (backdate.checkOut != null)
                      Text(
                        "Out: ${_formatDateTime(backdate.checkOut!)}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    if (backdate.checkIn == null ||
                        (backdate.checkOut != null &&
                            backdate.checkIn!.isBefore(backdate.checkOut!))) {
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
    ));
  }

  IconData _getIcon() {
    if (backdate.checkIn == null) {
      return Icons.circle_outlined;
    } else if (backdate.checkOut == null ||
        (backdate.checkOut != null &&
            backdate.checkIn!.isAfter(backdate.checkOut!))) {
      return Icons.access_time;
    } else {
      return Icons.check_circle_outline;
    }
  }

  Color _getIconColor() {
    if (backdate.checkIn == null) {
      return Colors.red;
    } else if (backdate.checkOut == null ||
        (backdate.checkOut != null &&
            backdate.checkIn!.isAfter(backdate.checkOut!))) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  }

//   void _showCheckInConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text('Check-In Confirmation'),
//           content: Text('Are you sure you want to check in?'),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Confirm'),
//               onPressed: () {
//                 context.read<BackdateBloc>().add(UpdateBackdateStatus(backdate.name, isCheckIn: true));
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showCheckOutConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: Text('Check-Out Confirmation'),
//           content: Text('Are you sure you want to check out?'),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Confirm'),
//               onPressed: () {
//                 context.read<BackdateBloc>().add(UpdateBackdateStatus(backdate.name, isCheckIn: false));
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

  Future<void> _showCheckInConfirmation(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // After selecting date and time, trigger Bloc event for check-in
        context.read<BackdateBloc>().add(UpdateBackdateStatus(
            backdate.name, selectedDateTime,
            isCheckIn: true));
      }
    }
  }

  Future<void> _showCheckOutConfirmation(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // After selecting date and time, trigger Bloc event for check-out
        context.read<BackdateBloc>().add(UpdateBackdateStatus(
            backdate.name, selectedDateTime,
            isCheckIn: false));
      }
    }
  }

  void _navigateToLeavesForm(BuildContext context) {
    // Navigasi ke halaman form leaves
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BackdateLeaves()),
    );
  }
}

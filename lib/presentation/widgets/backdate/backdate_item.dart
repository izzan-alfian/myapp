import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/back_date_model.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_event.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_state.dart';
import 'package:myapp/presentation/widgets/backdate/backdate_leaves.dart';

class BackdateItem extends StatelessWidget {
  final BackDate backdate; // Field backdate
  final DateTime? selectedCheckInTime;
  final DateTime? selectedCheckOutTime;

  const BackdateItem({
    Key? key,
    required this.backdate,
    required this.selectedCheckInTime,
    required this.selectedCheckOutTime,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocListener<BackdateBloc, BackdateState>(
      listener: (context, state) {
        if (state is BackdateUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Backdate updated successfully!'),
              backgroundColor: Colors.green,
            ));
        } else if (state is BackdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ));
        }
      },
      child: BlocBuilder<BackdateBloc, BackdateState>(
        builder: (context, state) {
          if (state is BackDateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BackdateError) {
            return Center(child: Text(state.message));
          } else if (state is BackdateLoaded) {
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
                          Text(
                            backdate.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          Text(backdate.position),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (backdate.checkIn != null)
                          Text(
                            "In: ${_formatTime(backdate.checkIn!)}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        if (backdate.checkOut != null)
                          Text(
                            "Out: ${_formatTime(backdate.checkOut!)}",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        _handleCheckInOrOut(context);
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
          }
          return SizedBox.shrink(); // Mengembalikan widget kosong jika state tidak dikenali
        },
      ),
    );
  }

  // Format jam saja (tanpa tanggal)
  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }


  // Fungsi untuk menangani check-in atau check-out
  void _handleCheckInOrOut(BuildContext context) {
    if (selectedCheckInTime == null) {
      // Jika belum ada waktu check-in yang dipilih dari kalender
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select check-in time from the calendar'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (backdate.checkIn == null) {
      // Lakukan check-in
      context.read<BackdateBloc>().add(
        UpdateBackdateStatus(
          name: backdate.name, // Pastikan backdate.name ada
          selectedDateTime: selectedCheckInTime!,
          isCheckIn: true,
        ),
      );
    } else if (backdate.checkOut == null) {
      // Lakukan check-out
      if (selectedCheckOutTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select check-out time from the calendar'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Validasi bahwa waktu check-out tidak sebelum check-in
      if (selectedCheckOutTime!.isBefore(backdate.checkIn!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Check-out time cannot be earlier than check-in time'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Lakukan check-out
      context.read<BackdateBloc>().add(
        UpdateBackdateStatus(
          name: backdate.name, // Pastikan backdate.name ada
          selectedDateTime: selectedCheckOutTime!,
          isCheckIn: false,
        ),
      );
    }
  }
   IconData _getIcon() {
    if (backdate.checkIn == null) {
      return Icons.circle_outlined;
    } else if (backdate.checkOut == null) {
      return Icons.access_time;
    } else {
      return Icons.check_circle_outline;
    }
  }

  Color _getIconColor() {
    if (backdate.checkIn == null) {
      return Colors.red;
    } else if (backdate.checkOut == null) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}

 

  void _navigateToLeavesForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BackdateLeaves()),
    );
  }


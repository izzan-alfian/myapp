import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

class AttendancesBloc extends Bloc<AttendancesEvent, AttendancesState> {
  List<Attendance> allAttendances = []; // Menyimpan semua data attendances

  AttendancesBloc() : super(AttendanceLoading()) {
    on<FetchAttendance>((event, emit) {
      try {
        // Dummy data attendances
        List<Attendance> dummyData = [
          Attendance(
            name: "Alexander Graham",
            position: "Manpower",
            // time: DateTime.now(),
            checkIn: DateTime.now(),
            checkOut: DateTime.now(),
          ),
          Attendance(
            name: "John Doe",
            position: "Supervisor",
            // time: DateTime.now(),
            checkIn: DateTime.now(),
            checkOut: DateTime.now(),
          ),
          Attendance(
            name: "Jane Smith",
            position: "Project Manager",
            // time: DateTime.now(),
            checkIn: DateTime.now(),
            checkOut: DateTime.now(),
          ),
          Attendance(
            name: "John Wick",
            position: "Manpower",
            // time: DateTime.now(),
            checkIn:DateTime.now(),
            checkOut: DateTime.now(),
          ),
        ];

        allAttendances = dummyData; // Menyimpan semua data
        emit(AttendanceLoaded(dummyData));
      } catch (e) {
        emit(AttendanceError("Failed to fetch data"));
      }
    });

  // Handle FilterAttendancesEvent
      on<FilterAttendancesEvent>((event, emit) {
      print("Filter Event Called: ${event.filter}");
      if (state is AttendanceLoaded) {
        List<Attendance> filteredAttendances;

        // Mengambil semua attendances yang ada
        filteredAttendances = allAttendances;

        if (event.filter == 'Non-checked') {
          // Attendances yang belum melakukan check-in ataupun check-out
          filteredAttendances = filteredAttendances.where((attendance) =>
              attendance.checkIn == null && attendance.checkOut == null).toList();
        } else if (event.filter == 'Checked in') {
          // Attendances yang sudah check-in tetapi belum check-out
          filteredAttendances = filteredAttendances.where((attendance) =>
              attendance.checkIn != null && attendance.checkOut == null).toList();
        } else if (event.filter == 'Checked out') {
          // Attendances yang sudah check-out
          filteredAttendances = filteredAttendances.where((attendance) =>
              attendance.checkIn != null && attendance.checkOut != null).toList();
        }

        // Emit data terfilter
        emit(AttendanceLoaded(filteredAttendances));
      }
    });
  }
}

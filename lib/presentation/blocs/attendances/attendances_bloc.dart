import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

class AttendancesBloc extends Bloc<AttendancesEvent, AttendancesState> {
  List<Attendance> allAttendances = [];

  AttendancesBloc() : super(AttendanceLoading()) {
    on<FetchAttendance>(_onFetchAttendance);
    on<FilterAttendancesEvent>(_onFilterAttendances);
    on<UpdateAttendanceStatus>(_onUpdateAttendanceStatus);

  }

  void _onFetchAttendance(FetchAttendance event, Emitter<AttendancesState> emit) {
    try {
      // Dummy data attendances
      allAttendances = [
        Attendance(name: "Alexander Graham", position: "Manpower"),
        Attendance(name: "John Doe", position: "Supervisor"),
        Attendance(name: "Jane Smith", position: "Project Manager"),
        Attendance(name: "John Wick", position: "Manpower"),
      ];
      emit(AttendanceLoaded(allAttendances));
    } catch (e) {
      emit(AttendanceError("Failed to fetch data"));
    }
  }

    void _onFetchAttendanceByDate(FetchAttendanceByDate event, Emitter<AttendancesState> emit) {
    if (state is AttendanceLoaded) {
      final date = event.date;
      List<Attendance> filteredAttendances = allAttendances.where((attendance) {
        return attendance.checkIn != null && 
               attendance.checkIn!.year == date.year && 
               attendance.checkIn!.month == date.month && 
               attendance.checkIn!.day == date.day;
      }).toList();
      
      emit(AttendanceLoaded(filteredAttendances));
    }
  }

void _onFilterAttendances(FilterAttendancesEvent event, Emitter<AttendancesState> emit) {
  if (state is AttendanceLoaded) {
    List<Attendance> filteredAttendances = allAttendances;

    if (event.filter == 'Non-checked') {
      filteredAttendances = filteredAttendances.where((a) => a.checkIn == null).toList();
    } else if (event.filter == 'Checked in') {
      filteredAttendances = filteredAttendances.where((a) {
          if (a.checkIn == null) return false;
          if (a.checkOut == null) return true;
          return a.checkIn!.isAfter(a.checkOut!);
        }).toList();
    } else if (event.filter == 'Checked out') {
      filteredAttendances = filteredAttendances.where((a) =>
        a.checkOut != null &&
        a.checkIn != null &&
        a.checkIn!.isBefore(a.checkOut!) // Check if latest check-in is before the check-out
      ).toList();
    }

    emit(AttendanceLoaded(filteredAttendances));
  }
}


  void _onUpdateAttendanceStatus(UpdateAttendanceStatus event, Emitter<AttendancesState> emit) {
    final index = allAttendances.indexWhere((a) => a.name == event.name);
    if (index != -1) {
      final attendance = allAttendances[index];
      if (event.isCheckIn) {
        // Always update checkIn time for a new check-in
        allAttendances[index] = attendance.copyWith(checkIn: DateTime.now());
      } else {
        // Update checkOut time
        allAttendances[index] = attendance.copyWith(checkOut: DateTime.now());
      }
      emit(AttendanceLoaded(List.from(allAttendances)));
    }
  }



}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
// import 'package:myapp/data/repositories/attendances/attendances_repository.dart';
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
        Attendance(name: "Alexander Graham Bellanio G", position: "Manpower"),
        Attendance(name: "John Doe", position: "Supervisor"),
        Attendance(name: "Jane Smith", position: "Project Manager"),
        Attendance(name: "John Wick", position: "Manpower"),
        Attendance(name: "Michael Johnson", position: "Manager"),
        Attendance(name: "Emily Davis", position: "Manpower"),
        Attendance(name: "Robert Brown", position: "Software Enngineer"),
        Attendance(name: "Sophia Wilso", position: "Product Manager"),
        Attendance(name: "Lucas Taylor", position: "Marketing Manager"),
      ];
      emit(AttendanceLoaded(allAttendances));
    } catch (e) {
      emit(AttendanceError("Failed to fetch data"));
    }
  }


void _onFilterAttendances(FilterAttendancesEvent event, Emitter<AttendancesState> emit) {
  if (state is AttendanceLoaded) {
    List<Attendance> filteredAttendances = allAttendances;

    // Debugging: Print semua attendances sebelum filter
    print("All attendances: ");
    for (var a in allAttendances) {
      print("checkIn: ${a.checkIn}, checkOut: ${a.checkOut}");
    }

    if (event.filter == 'Non-checked') {
      filteredAttendances = filteredAttendances.where((a) => a.checkIn == null).toList();
    } else if (event.filter == 'Checked in') {
      filteredAttendances = filteredAttendances.where((a) {
        if (a.checkIn == null) return false; // Jika belum pernah check in
        if (a.checkOut == null) return true; // Sudah check in tapi belum check out
        
        // Logika tambahan: Periksa apakah check-in terakhir adalah yang paling baru
        return a.checkIn!.isAfter(a.checkOut!); // Tetap di "Checked in" jika check-in terbaru lebih lambat dari check-out terakhir
      }).toList();
    } else if (event.filter == 'Checked out') {
      filteredAttendances = filteredAttendances.where((a) =>
        a.checkOut != null &&
        a.checkIn != null &&
        a.checkIn!.isBefore(a.checkOut!) // Terfilter di "Checked out" jika check-in sebelum check-out
      ).toList();
    }

    // Debugging: Print hasil filter
    print("Filtered attendances: ");
    for (var a in filteredAttendances) {
      print("checkIn: ${a.checkIn}, checkOut: ${a.checkOut}");
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
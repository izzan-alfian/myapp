import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
// import 'package:myapp/data/repositories/attendances/attendances_repository.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

// class AttendancesBloc extends Bloc<AttendancesEvent, AttendancesState> {
//   final AttendancesRepository attendanceRepository;

//   AttendancesBloc({required this.attendanceRepository}) : super(AttendanceInitial()) {
//     on<FetchAttendanceByDate>(_onFetchAttendanceByDate);
//   }

//   void _onFetchAttendanceByDate(FetchAttendanceByDate event, Emitter<AttendancesState> emit) async {
//     emit(AttendanceLoading()); // Tampilkan loading saat proses berlangsung
    
//     try {
//       // Ambil data dari repository
//       final attendances = await attendanceRepository.getAttendancesByDate(event.date);
//       emit(AttendanceLoaded(attendances)); // Emit state data yang sudah dimuat
//     } catch (error) {
//       emit(AttendanceError("Failed to load attendance data")); // Emit error jika gagal
//     }
//   }
// }


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

  Attendance(
      name: 'John Doe',
      position: 'Developer',
      checkIn: DateTime.now().subtract(Duration(days: 1, hours: 8)),
      checkOut: DateTime.now().subtract(Duration(days: 1, hours: 0, minutes: 30)), // Check out setelah 7,5 jam
    ),
    Attendance(
      name: 'Jane Smith',
      position: 'Designer',
      checkIn: DateTime.now().subtract(Duration(days: 2, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 2, hours: 1)), // Check out setelah 8 jam
    ),
    Attendance(
      name: 'Michael Johnson',
      position: 'Manager',
      checkIn: DateTime.now().subtract(Duration(days: 3, hours: 10)),
      checkOut: DateTime.now().subtract(Duration(days: 3, hours: 1, minutes: 15)), // Check out setelah 8 jam 45 menit
    ),
    Attendance(
      name: 'Emily Davis',
      position: 'HR Specialist',
      checkIn: DateTime.now().subtract(Duration(days: 4, hours: 8, minutes: 15)),
      checkOut: DateTime.now().subtract(Duration(days: 4, hours: 0, minutes: 45)), // Check out setelah 7 jam 30 menit
    ),
    Attendance(
      name: 'Robert Brown',
      position: 'Software Engineer',
      checkIn: DateTime.now().subtract(Duration(days: 5, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 5, hours: 2)), // Check out setelah 7 jam
    ),
    Attendance(
      name: 'Sophia Wilson',
      position: 'Product Manager',
      checkIn: DateTime.now().subtract(Duration(days: 6, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 6, hours: 2, minutes: 15)), // Check out setelah 6 jam 45 menit
    ),
    Attendance(
      name: 'David Lee',
      position: 'UX Designer',
      checkIn: DateTime.now().subtract(Duration(days: 7, hours: 8, minutes: 30)),
      checkOut: DateTime.now().subtract(Duration(days: 7, hours: 0, minutes: 30)), // Check out setelah 8 jam
    ),
    Attendance(
      name: 'Lucas Taylor',
      position: 'QA Engineer',
      checkIn: DateTime.now().subtract(Duration(days: 8, hours: 10)),
      checkOut: null, // Belum check out (masih di dalam waktu kerja)
    ),
    Attendance(
      name: 'Olivia Martinez',
      position: 'Marketing Specialist',
      checkIn: DateTime.now().subtract(Duration(days: 9, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 9, hours: 1, minutes: 45)), // Check out setelah 7 jam 15 menit
    ),
    Attendance(
      name: 'Ethan Harris',
      position: 'Support Engineer',
      checkIn: DateTime.now().subtract(Duration(days: 10, hours: 8)),
      checkOut: DateTime.now().subtract(Duration(days: 10, hours: 1, minutes: 30)), // Check out setelah 6 jam 30 menit
    ),
    // Tambahkan lebih banyak data dummy sesuai kebutuhan
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
      
  //     emit(AttendanceLoaded(filteredAttendances));
  //     try {
  //     emit(AttendanceLoading()); // Tampilkan loading saat proses berlangsung
  //     final attendances = await attendanceRepository.getAttendancesByDate(event.date); // Ambil data berdasarkan tanggal
  //     emit(AttendanceLoaded(attendances)); // Tampilkan data kehadiran yang sudah dimuat
  //   } catch (error) {
  //     emit(AttendanceError("Failed to load attendance data")); // Tampilkan pesan error jika gagal
  // }
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
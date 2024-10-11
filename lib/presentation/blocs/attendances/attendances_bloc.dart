import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/data/repositories/attendances/attendances_repository_impl.dart';
import 'package:myapp/domain/repositories/attendances/attendances_repository.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

class AttendancesBloc extends Bloc<AttendancesEvent, AttendancesState> {
  final AttendancesRepository attendanceRepository;
  List<Attendance> allAttendances = [];

  AttendancesBloc({required this.attendanceRepository}) : super(AttendanceLoading()) {
    on<FetchAttendance>(_onFetchAttendance);
    on<FetchAttendanceByDate>(_onFetchAttendanceByDate);
    on<FilterAttendancesEvent>(_onFilterAttendances);
    on<UpdateAttendanceStatus>(_onUpdateAttendanceStatus);
  }

 Future<void> _onFetchAttendance(FetchAttendance event, Emitter<AttendancesState> emit) async {
  emit(AttendanceLoading()); // Tampilkan loading saat proses berlangsung
  try {
    // Ambil data dari repository
    final attendances = await attendanceRepository.fetchAttendances(DateTime(date)); // Pastikan nama metode sama
    allAttendances = attendances; // Simpan semua attendances
    emit(AttendanceLoaded(attendances)); // Emit state data yang sudah dimuat
  } catch (error) {
    emit(AttendanceError("Failed to load attendance data")); // Emit error jika gagal
  }
}


  Future<void> _onFetchAttendanceByDate(FetchAttendanceByDate event, Emitter<AttendancesState> emit) async {
    emit(AttendanceLoading()); // Tampilkan loading saat proses berlangsung
    try {
      final attendances = allAttendances.where((attendance) {
        return attendance.checkIn != null &&
            attendance.checkIn!.year == event.date.year &&
            attendance.checkIn!.month == event.date.month &&
            attendance.checkIn!.day == event.date.day;
      }).toList();

      emit(AttendanceLoaded(attendances)); // Emit state data yang sudah dimuat
    } catch (error) {
      emit(AttendanceError("Failed to load attendance data")); // Emit error jika gagal
    }
  }

  void _onFilterAttendances(FilterAttendancesEvent event, Emitter<AttendancesState> emit) {
    if (state is AttendanceLoaded) {
      List<Attendance> filteredAttendances = List.from(allAttendances);

      if (event.filter == 'Non-checked') {
        filteredAttendances = filteredAttendances.where((a) => a.checkOut == null).toList();
      } else if (event.filter == 'Checked in') {
        filteredAttendances = filteredAttendances.where((a) {
          return a.checkIn != null && (a.checkOut == null || a.checkIn!.isAfter(a.checkOut!));
        }).toList();
      } else if (event.filter == 'Checked out') {
        filteredAttendances = filteredAttendances.where((a) =>
            a.checkOut != null && a.checkIn != null && a.checkIn!.isBefore(a.checkOut!)).toList();
      }

      emit(AttendanceLoaded(filteredAttendances));
    } else {
      emit(AttendanceError("No attendance data available to filter")); // Emit error jika state tidak cocok
    }
  }

  void _onUpdateAttendanceStatus(UpdateAttendanceStatus event, Emitter<AttendancesState> emit) {
    final index = allAttendances.indexWhere((a) => a.name == event.name);
    if (index != -1) {
      final attendance = allAttendances[index];
      final updatedAttendance = event.isCheckIn
          ? attendance.copyWith(checkIn: DateTime.now())
          : attendance.copyWith(checkOut: DateTime.now());

      allAttendances[index] = updatedAttendance; // Update attendance yang sesuai

      emit(AttendanceLoaded(List.from(allAttendances)));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';
import 'package:myapp/presentation/pages/attendances/attendances.dart';

class AttendancesBloc extends Bloc<AttendancesEvent, AttendancesState> {
  AttendancesBloc() : super(AttendanceLoading()) {
    on<FetchAttendance>((event, emit) {
      try {
        // Data dummy
        List<Attendance> dummyData = [
          Attendance(name: "Alexander Graham", position: "Manpower", checkIn: "08:00", checkOut: "16:00"),
          Attendance(name: "John Doe", position: "Developer", checkIn: "09:00", checkOut: "17:00"),
          Attendance(name: "Jane Smith", position: "Designer", checkIn: "08:30", checkOut: "16:30"),
          // Tambahkan data dummy lainnya
        ];

        emit(AttendanceLoaded(dummyData.cast<Attendances>()));
      } catch (e) {
        emit(AttendanceError("Failed to fetch data"));
      }
    });
  }
}

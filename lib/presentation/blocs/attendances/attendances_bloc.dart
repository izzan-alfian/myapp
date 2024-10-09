import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';

class AttendancesBloc extends Bloc<AttendancesEvent, AttendancesState> {
  AttendancesBloc() : super(AttendanceLoading()) {
    on<FetchAttendance>((event, emit) {
      try {
        // Data dummy
        List<Attendance> dummyData = [
          Attendance(
              name: "Alexander Graham",
              position: "Manpower",
              time: DateTime.now(),
              checkIn: true,
              checkOut: true,),
          Attendance(
              name: "John Doe",
              position: "Supervisor",
              time: DateTime.now(),
              checkIn: true,
              checkOut:true,),
          Attendance(
              name: "Jane Smith",
              position: "Project Manager",
              time: DateTime.now(),
              checkIn: true,
              checkOut: true,),
            Attendance(
              name: "John Wick",
              position: "Manpower",
              time: DateTime.now(),
              checkIn: true,
              checkOut: true,),
          // Tambahkan data dummy lainnya
        ];

        emit(AttendanceLoaded(dummyData.cast<Attendance>()));
      } catch (e) {
        emit(AttendanceError("Failed to fetch data"));
      }
    });
  }
}

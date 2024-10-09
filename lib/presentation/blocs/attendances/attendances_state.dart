import 'package:myapp/data/models/attendances_model.dart';

abstract class AttendancesState {}

class AttendanceLoading extends AttendancesState {}

class AttendanceLoaded extends AttendancesState {
  final List<Attendance> attendances;

  AttendanceLoaded(this.attendances);
}

class AttendanceError extends AttendancesState {
  final String message;

  AttendanceError(this.message);
}


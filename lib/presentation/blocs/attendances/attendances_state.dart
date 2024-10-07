import 'package:myapp/presentation/pages/attendances/attendances.dart';

abstract class AttendancesState {}

class AttendanceLoading extends AttendancesState {}

class AttendanceLoaded extends AttendancesState {
  final List<Attendances> attendances;

  AttendanceLoaded(this.attendances);
}

class AttendanceError extends AttendancesState {
  final String message;

  AttendanceError(this.message);
}

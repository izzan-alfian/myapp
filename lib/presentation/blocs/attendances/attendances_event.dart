abstract class AttendancesEvent {}

class FetchAttendance extends AttendancesEvent {
    final DateTime date;
    FetchAttendance({required this.date});
}

class FilterAttendancesEvent extends AttendancesEvent {
  final String filter;

  FilterAttendancesEvent(this.filter);
}

class UpdateAttendanceStatus extends AttendancesEvent {
  final String name;
  final bool isCheckIn;
  UpdateAttendanceStatus(this.name, {required this.isCheckIn});
}

class FetchAttendanceByDate extends AttendancesEvent {
  final DateTime date;

  FetchAttendanceByDate({required this.date});
}





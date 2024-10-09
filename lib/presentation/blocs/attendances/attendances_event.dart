abstract class AttendancesEvent {}

class FetchAttendance extends AttendancesEvent {}

class FilterAttendancesEvent extends AttendancesEvent {
  final String filter;

  FilterAttendancesEvent(this.filter);
}


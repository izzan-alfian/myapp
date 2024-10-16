abstract class BackdateEvent {}

class FetchBackdate extends BackdateEvent {
    final DateTime date;
    FetchBackdate({required this.date});
}

class FilterBackdateEvent extends BackdateEvent {
  final String filter;

  FilterBackdateEvent(this.filter);
}

class UpdateBackdateStatus extends BackdateEvent {
  final String name;
  final bool isCheckIn;
  UpdateBackdateStatus(this.name, {required this.isCheckIn});
}





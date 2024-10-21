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
  final DateTime selectedDateTime;
  final bool isCheckIn;

  UpdateBackdateStatus({
    required this.name,
    required this.selectedDateTime,
    required this.isCheckIn,
  });
}



class UpdateBackdateWithDateTime extends BackdateEvent {
  final DateTime selectedDateTime;

  UpdateBackdateWithDateTime({required this.selectedDateTime});

  @override
  List<Object> get props => [selectedDateTime];
}





abstract class DailyReportState {}

class DailyReportInitial extends DailyReportState {}

class DailyReportLoading extends DailyReportState {}

class DailyReportLoaded extends DailyReportState {
  final List<String> projects;
  final List<String> serviceProviders;
  final List<String> supervisorConsultants;
  final List<String> plannerConsultants;

  DailyReportLoaded({
    required this.projects,
    required this.serviceProviders,
    required this.supervisorConsultants,
    required this.plannerConsultants,
  });
}

class DailyReportError extends DailyReportState {
  final String message;

  DailyReportError(this.message);
}

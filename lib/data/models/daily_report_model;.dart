class DailyReport {
  final String project;
  final String serviceProvider;
  final String supervisorConsultant;
  final String plannerConsultant;

  DailyReport({
    required this.project,
    required this.serviceProvider,
    required this.supervisorConsultant,
    required this.plannerConsultant,
  });

  DailyReport copyWith({
    String? project,
    String? serviceProvider,
    String? supervisorConsultant,
    String? plannerConsultant,
  }) {
    return DailyReport(
      project: project ?? this.project,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      supervisorConsultant: supervisorConsultant ?? this.supervisorConsultant,
      plannerConsultant: plannerConsultant ?? this.plannerConsultant,
    );
  }
}

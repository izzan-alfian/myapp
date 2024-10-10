import 'package:flutter_bloc/flutter_bloc.dart';
import 'daily_report_event.dart';
import 'daily_report_state.dart';
import 'package:myapp/data/repositories/project_repository_impl.dart';
import 'package:myapp/data/repositories/service_provider_repository_impl.dart';
import 'package:myapp/data/repositories/supervisor_consultant_repository_impl.dart';
import 'package:myapp/data/repositories/planner_consultant_repository_impl.dart';

class DailyReportBloc extends Bloc<DailyReportEvent, DailyReportState> {
  final ProjectRepositoryImpl projectRepository;
  final ServiceProviderRepositoryImpl serviceProviderRepository;
  final SupervisorConsultantRepositoryImpl supervisorConsultantRepository;
  final PlannerConsultantRepositoryImpl plannerConsultantRepository;

  DailyReportBloc({
    required this.projectRepository,
    required this.serviceProviderRepository,
    required this.supervisorConsultantRepository,
    required this.plannerConsultantRepository,
  }) : super(DailyReportInitial()) {
    on<FetchDailyReportData>(_onFetchDailyReportData);
  }

  Future<void> _onFetchDailyReportData(
      FetchDailyReportData event, Emitter<DailyReportState> emit) async {
    emit(DailyReportLoading());
    try {
      final projects = await projectRepository.fetchProjects();
      final serviceProviders = await serviceProviderRepository.fetchServiceProviders();
      final supervisorConsultants = await supervisorConsultantRepository.fetchSupervisorConsultants();
      final plannerConsultants = await plannerConsultantRepository.fetchPlannerConsultants();

      emit(DailyReportLoaded(
        projects: projects,
        serviceProviders: serviceProviders,
        supervisorConsultants: supervisorConsultants,
        plannerConsultants: plannerConsultants,
      ));
    } catch (e) {
      emit(DailyReportError("Failed to load daily report data"));
    }
  }
}

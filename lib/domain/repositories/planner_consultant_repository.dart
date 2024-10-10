import '../entities/planner_consultant.dart';

abstract class PlannerConsultantRepository {
  Future<List<String>> fetchPlannerConsultants();
}
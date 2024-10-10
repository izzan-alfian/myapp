import 'dart:async';
import '../../domain/repositories/planner_consultant_repository.dart';

class PlannerConsultantRepositoryImpl implements PlannerConsultantRepository {
  @override
  Future<List<String>> fetchPlannerConsultants() async {
    await Future.delayed(Duration(seconds: 1));
    return ['Provider One', 'Provider Two', 'Provider Three'];
  }
}

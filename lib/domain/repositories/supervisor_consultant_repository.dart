import '../entities/supervisor_consultant.dart';

abstract class SupervisorConsultantRepository {
  Future<List<String>> fetchSupervisorConsultants();
}
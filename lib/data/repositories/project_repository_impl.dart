import 'dart:async';
import '../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  @override
  Future<List<String>> fetchProjects() async {
    // Simulating a delay
    await Future.delayed(Duration(seconds: 1));
    // Returning mock data
    return ['Project Alpha', 'Project Beta', 'Project Gamma'];
  }
}

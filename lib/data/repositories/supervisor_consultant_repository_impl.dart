// Example for service_provider_repository_impl.dart
import 'dart:async';
import '../../domain/repositories/supervisor_consultant_repository.dart';

class SupervisorConsultantRepositoryImpl implements SupervisorConsultantRepository {
  @override
  Future<List<String>> fetchSupervisorConsultants() async {
    await Future.delayed(Duration(seconds: 1));
    return ['Provider One', 'Provider Two', 'Provider Three'];
  }
}

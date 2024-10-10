// Example for service_provider_repository_impl.dart
import 'dart:async';
import '../../domain/repositories/service_provider_repository.dart';

class ServiceProviderRepositoryImpl implements ServiceProviderRepository {
  @override
  Future<List<String>> fetchServiceProviders() async {
    await Future.delayed(Duration(seconds: 1));
    return ['Provider One', 'Provider Two', 'Provider Three'];
  }
}

import 'package:myapp/domain/entities/attendances/attendances_entities.dart';

abstract class AttendancesRepository {
  Future<List<AttendancesEntities>> fetchAttendances(DateTime date);
}
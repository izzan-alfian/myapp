import 'package:myapp/domain/entities/back_date_entities.dart';

abstract class BackDateRepository {
  Future<List<BackDateEntities>> fetchBackDate(DateTime date);
}

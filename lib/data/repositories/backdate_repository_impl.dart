import 'package:myapp/data/models/back_date_model.dart';
import 'package:myapp/domain/entities/back_date_entities.dart';
import 'package:myapp/domain/repositories/back_date_repository.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_event.dart';

class BackdateRepositoryImpl implements BackDateRepository {
  @override
  Future<List<BackDate>> getBackdate(DateTime date) async {
    // Ambil data dari database atau API, ini hanya contoh data dummy
    List<BackDate> allBackDate = [];

    return allBackDate.where((backdate) {
      return backdate.checkIn?.day == date.day &&
          backdate.checkIn?.month == date.month &&
          backdate.checkIn?.year == date.year;
    }).toList();
  }

  //   // Filter berdasarkan tanggal checkIn yang sesuai
  //   List<BackDate> filteredBackdate = allBackDate.where((backdate) {
  //     return backdate.checkIn?.day == date.day &&
  //         backdate.checkIn?.month == date.month &&
  //         backdate.checkIn?.year == date.year;
  //   }).toList();

  //   // Jika BackDateEntities berbeda dari BackDate, konversikan datanya
  //   List<BackDateEntities> backdateEntities = filteredBackdate.map((backdate) {
  //     return BackDateEntities(
  //       name: backdate.name,
  //       position: backdate.position,
  //       checkIn: backdate.checkIn,
  //       checkOut: backdate.checkOut,
  //     );
  //   }).toList();

  //   return backdateEntities;
  // }
  
  @override
  Future<List<BackDateEntities>> fetchBackDate(DateTime date) {
    // TODO: implement fetchBackDate
    throw UnimplementedError();
  }
}

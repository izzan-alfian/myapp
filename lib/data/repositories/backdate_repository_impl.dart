import 'package:myapp/data/models/back_date_model.dart';
import 'package:myapp/domain/entities/back_date_entities.dart';
import 'package:myapp/domain/repositories/back_date_repository.dart';

class BackdateRepositoryImpl implements BackDateRepository {
  @override
  Future<List<BackDateEntities>> FetchBackdates(DateTime date) async {
    // Ambil data dari database atau API, ini hanya contoh data dummy
    List<BackDate> allBackDate = [
      BackDate(name: "Dinda Juliana", position: "Manpower", checkIn: DateTime.now(), checkOut: null),
      BackDate(name: "John Doe", position: "Supervisor", checkIn: DateTime.now().subtract(Duration(days: 1)), checkOut: DateTime.now().subtract(Duration(days: 1))),
      // Tambahkan data lainnya
    ];

    // Filter berdasarkan tanggal checkIn yang sesuai
    List<BackDate> filteredBackdate = allBackDate.where((backdate) {
      return backdate.checkIn?.day == date.day &&
          backdate.checkIn?.month == date.month &&
          backdate.checkIn?.year == date.year;
    }).toList();

    // Jika BackDateEntities berbeda dari BackDate, konversikan datanya
    List<BackDateEntities> backdateEntities = filteredBackdate.map((backdate) {
      return BackDateEntities(
        name: backdate.name,
        position: backdate.position,
        checkIn: backdate.checkIn,
        checkOut: backdate.checkOut,
      );
    }).toList();

    return backdateEntities;
  }
  
  @override
  Future<List<BackDateEntities>> getBackDates(DateTime date) {
    // TODO: implement getBackDates
    throw UnimplementedError();
  }
}

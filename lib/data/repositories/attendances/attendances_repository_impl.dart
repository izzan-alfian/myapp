import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/domain/entities/attendances/attendances_entities.dart';
import 'package:myapp/domain/repositories/attendances/attendances_repository.dart';

class AttendancesRepositoryImpl implements AttendancesRepository {
  Future<List<Attendance>> getAttendancesByDate(DateTime date) async {
    // Contoh: Ambil data dari database atau API
    // Misal ambil dari data dummy untuk sekarang
    List<Attendance> allAttendances = [
        // Attendance(name: "Alexander Graham", position: "Manpower"),
        // Attendance(name: "John Doe", position: "Supervisor"),
        // Attendance(name: "Jane Smith", position: "Project Manager"),
        // Attendance(name: "John Wick", position: "Manpower"),
        // Attendance(name: "Michael Johnson", position: "Manager"),
        // Attendance(name: "Emily Davis", position: "Manpower"),
        // Attendance(name: "Robert Brown", position: "Software Enngineer"),
        // Attendance(name: "Sophia Wilso", position: "Product Manager"),
        // Attendance(name: "Lucas Taylor", position: "Marketing Manager"),

    ];

    return allAttendances.where((attendance) {
      return attendance.checkIn?.day == date.day &&
             attendance.checkIn?.month == date.month &&
             attendance.checkIn?.year == date.year;
    }).toList();
  }


  // @override
  // Future<List<AttendancesEntities>> fetchAttendances(DateTime date) async {
  //   // Simulate fetching data by filtering the dummy data based on the date
  //   List<AttendancesEntities> filteredAttendances = _dummyAttendances.where((attendance) {
  //     return attendance.checkIn != null &&
  //         attendance.checkIn!.year == date.year &&
  //         attendance.checkIn!.month == date.month &&
  //         attendance.checkIn!.day == date.day;
  //   }).toList();

  //   // Return the filtered dummy data
  //   return Future.delayed(
  //     Duration(seconds: 1), // Simulate network delay
  //     () => filteredAttendances,
  //   );

  @override
  Future<List<AttendancesEntities>> fetchAttendances(DateTime date) {
    // TODO: implement fetchAttendances
    throw UnimplementedError();
  }
}

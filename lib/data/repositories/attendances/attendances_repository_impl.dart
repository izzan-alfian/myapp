import 'package:myapp/data/models/attendances_model.dart';
import 'package:myapp/domain/entities/attendances/attendances_entities.dart';
import 'package:myapp/domain/repositories/attendances/attendances_repository.dart';

class AttendancesRepositoryImpl implements AttendancesRepository {
  Future<List<Attendance>> getAttendancesByDate(DateTime date) async {
    // Contoh: Ambil data dari database atau API
    // Misal ambil dari data dummy untuk sekarang
    List<Attendance> allAttendances = [
        Attendance(name: "Alexander Graham", position: "Manpower", checkIn: DateTime.now()),
        Attendance(name: "John Doe", position: "Supervisor",checkIn: DateTime.now()),
        Attendance(name: "Jane Smith", position: "Project Manager"),
        Attendance(name: "John Wick", position: "Manpower"),

  Attendance(
      name: 'John Doe',
      position: 'Developer',
      checkIn: DateTime.now().subtract(Duration(days: 1, hours: 8)),
      checkOut: DateTime.now().subtract(Duration(days: 1, hours: 0, minutes: 30)), // Check out setelah 7,5 jam
    ),
    Attendance(
      name: 'Jane Smith',
      position: 'Designer',
      checkIn: DateTime.now().subtract(Duration(days: 2, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 2, hours: 1)), // Check out setelah 8 jam
    ),
    Attendance(
      name: 'Michael Johnson',
      position: 'Manager',
      checkIn: DateTime.now().subtract(Duration(days: 3, hours: 10)),
      checkOut: DateTime.now().subtract(Duration(days: 3, hours: 1, minutes: 15)), // Check out setelah 8 jam 45 menit
    ),
    Attendance(
      name: 'Emily Davis',
      position: 'HR Specialist',
      checkIn: DateTime.now().subtract(Duration(days: 4, hours: 8, minutes: 15)),
      checkOut: DateTime.now().subtract(Duration(days: 4, hours: 0, minutes: 45)), // Check out setelah 7 jam 30 menit
    ),
    Attendance(
      name: 'Robert Brown',
      position: 'Software Engineer',
      checkIn: DateTime.now().subtract(Duration(days: 5, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 5, hours: 2)), // Check out setelah 7 jam
    ),
    Attendance(
      name: 'Sophia Wilson',
      position: 'Product Manager',
      checkIn: DateTime.now().subtract(Duration(days: 6, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 6, hours: 2, minutes: 15)), // Check out setelah 6 jam 45 menit
    ),
    Attendance(
      name: 'David Lee',
      position: 'UX Designer',
      checkIn: DateTime.now().subtract(Duration(days: 7, hours: 8, minutes: 30)),
      checkOut: DateTime.now().subtract(Duration(days: 7, hours: 0, minutes: 30)), // Check out setelah 8 jam
    ),
    Attendance(
      name: 'Lucas Taylor',
      position: 'QA Engineer',
      checkIn: DateTime.now().subtract(Duration(days: 8, hours: 10)),
      checkOut: null, // Belum check out (masih di dalam waktu kerja)
    ),
    Attendance(
      name: 'Olivia Martinez',
      position: 'Marketing Specialist',
      checkIn: DateTime.now().subtract(Duration(days: 9, hours: 9)),
      checkOut: DateTime.now().subtract(Duration(days: 9, hours: 1, minutes: 45)), // Check out setelah 7 jam 15 menit
    ),
    Attendance(
      name: 'Ethan Harris',
      position: 'Support Engineer',
      checkIn: DateTime.now().subtract(Duration(days: 10, hours: 8)),
      checkOut: DateTime.now().subtract(Duration(days: 10, hours: 1, minutes: 30)), // Check out setelah 6 jam 30 menit
    ),
      Attendance(
        name: 'John Doe',
        position: 'Developer',
        checkIn: DateTime.now().subtract(Duration(days: 1, hours: 8)),
        checkOut: DateTime.now().subtract(Duration(days: 1, hours: 2)),
      ),
      Attendance(
        name: 'Jane Smith',
        position: 'Designer',
        checkIn: DateTime.now().subtract(Duration(days: 2, hours: 9)),
        checkOut: DateTime.now().subtract(Duration(days: 2, hours: 5)),
      ),

    ];

    return allAttendances.where((attendance) {
      return attendance.checkIn?.day == date.day &&
             attendance.checkIn?.month == date.month &&
             attendance.checkIn?.year == date.year;
    }).toList();
  }

  @override
  Future<List<AttendancesEntities>> fetchAttendances(DateTime date) {
    // TODO: implement fetchAttendances
    throw UnimplementedError();
  }
}

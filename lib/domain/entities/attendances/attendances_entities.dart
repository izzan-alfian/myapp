class AttendancesEntities {
  final String name;
  final String position;
  DateTime? checkIn;
  DateTime? checkOut;

   AttendancesEntities({
    required this.name,
    required this.position,
    this.checkIn,
    this.checkOut,
  });
}

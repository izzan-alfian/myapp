class BackDateEntities {
  final String name;
  final String position;
  DateTime? checkIn;
  DateTime? checkOut;

  BackDateEntities({
    required this.name,
    required this.position,
    this.checkIn,
    this.checkOut,
  });
}

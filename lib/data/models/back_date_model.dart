class BackDate {
  final String name;
  final String position;
  DateTime? checkIn;
  DateTime? checkOut;

  BackDate({
    required this.name,
    required this.position,
    this.checkIn,
    this.checkOut,
  });

  BackDate copyWith({
    String? name,
    String? position,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return BackDate(
      name: name ?? this.name,
      position: position ?? this.position,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }
}

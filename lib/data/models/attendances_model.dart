class Attendance {
  final String name;
  final String position;
  final DateTime time;
  final String checkIn;
  final String checkOut;

  // Constructor
  Attendance({
    required this.name,
    required this.position,
    required this.time,
    required this.checkIn,
    required this.checkOut,
  });

  // Factory method untuk membuat instance Attendance dari JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      name: json['name'] ?? '', // Handling jika datanya null
      position: json['position'] ?? '',
      time: DateTime.parse(json['time']),
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
    );
  }

  // Method untuk mengubah Attendance menjadi JSON (misalnya saat akan dikirim ke server)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'time': time.toIso8601String(), // Mengonversi ke format ISO 8601'
      'check_in': checkIn,
      'check_out': checkOut,
    };
  }
}

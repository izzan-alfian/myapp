



class Attendance {
  final String name;
  final String position;
  final String checkIn;
  final String checkOut;

  // Constructor
  Attendance({
    required this.name,
    required this.position,
    required this.checkIn,
    required this.checkOut,
  });

  // Factory method untuk membuat instance Attendance dari JSON
  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      name: json['name'] ?? '', // Handling jika datanya null
      position: json['position'] ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
    );
  }

  // Method untuk mengubah Attendance menjadi JSON (misalnya saat akan dikirim ke server)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'position': position,
      'check_in': checkIn,
      'check_out': checkOut,
    };
  }
}

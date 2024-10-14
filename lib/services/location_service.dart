// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
// import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';

// // Fungsi untuk mendapatkan lokasi
// Future<Position> _getCurrentLocation() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Cek apakah layanan lokasi diaktifkan
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Jika layanan lokasi tidak aktif, berikan notifikasi ke pengguna
//     return Future.error('Location services are disabled.');
//   }

//   // Cek izin lokasi
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Jika izin ditolak, berikan notifikasi
//       return Future.error('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     // Izin ditolak secara permanen
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   } 

//   // Dapatkan lokasi saat ini
//   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
// }

// void_showCheckInConfirmation(BuildContext context) async {
//   // Dapatkan lokasi saat check-in
//   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  
//   // Lakukan sesuatu dengan latitude dan longitude
//   double latitude = position.latitude;
//   double longitude = position.longitude;

//   // Logika untuk check-in dengan data lokasi
//   print("Check-in Location: Lat=$latitude, Long=$longitude");

//   // Kirim data check-in dengan lokasi
//   context.read<AttendancesBloc>().add(CheckInEvent(latitude: latitude, longitude: longitude));
// }

// void_showCheckOutConfirmation(BuildContext context) async {
//   // Dapatkan lokasi saat check-out
//   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  
//   // Lakukan sesuatu dengan latitude dan longitude
//   double latitude = position.latitude;
//   double longitude = position.longitude;

//   // Logika untuk check-out dengan data lokasi
//   print("Check-out Location: Lat=$latitude, Long=$longitude");

//   // Kirim data check-out dengan lokasi
//   context.read<AttendancesBloc>().add(CheckOutEvent(latitude: latitude, longitude: longitude));
// }

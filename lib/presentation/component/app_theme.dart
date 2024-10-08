import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Color(0xFFF5F5F5), // Warna background light
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white, // Background AppBar putih
      foregroundColor: Colors.black, // Warna teks AppBar hitam
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold, // Teks tebal di AppBar
      ),
      elevation: 0, // Menghilangkan bayangan di AppBar
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white, // Warna background navbar putih
        selectedItemColor: Colors.blueAccent, // Warna ikon dan teks saat dipilih
        unselectedItemColor: Colors.grey, // Warna ikon dan teks saat tidak dipilih
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Label tebal saat dipilih
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Label biasa saat tidak dipilih
        showUnselectedLabels: true, // Menampilkan label pada item yang tidak dipilih
      ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black, // Warna teks utama
        fontSize: 16,
      ),
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
  );
}

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Color(0xFFf0f0f0), // Warna background light
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
        backgroundColor: Color(0xFFb6bdc4), // Warna background navbar putih
        selectedItemColor: Color(0xFF33499e), // Warna ikon dan teks saat dipilih
        unselectedItemColor: Colors.grey, // Warna ikon dan teks saat tidak dipilih
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Label tebal saat dipilih
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Label biasa saat tidak dipilih
        showUnselectedLabels: true, // Menampilkan label pada item yang tidak dipilih
        elevation:0
      ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black, // Warna teks utama
        fontSize: 16,
      ),
    ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
  );
}

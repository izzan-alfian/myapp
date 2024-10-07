import 'package:flutter/material.dart';
import 'package:myapp/presentation/component/layout_navbar.dart';
import 'package:myapp/presentation/component/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Tidak perlu StatefulWidget jika hanya menampilkan LayoutNavbar
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme, // Atur theme jika diperlukan
      home: LayoutNavbar(), // Menggunakan LayoutNavbar sebagai halaman utama
    );
  }
}

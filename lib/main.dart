import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/component/layout_navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Tidak perlu StatefulWidget jika hanya menampilkan LayoutNavbar
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AttendancesBloc>(create: (context) => AttendancesBloc()..add(FetchAttendance()),)
      ],
      child: MaterialApp(
         theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white, // Pastikan ini putih
            selectedItemColor: Color(0xFF33499e),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            showUnselectedLabels: true,
          ),
        ),
      home: LayoutNavbar(),
          ),
     // Menggunakan LayoutNavbar sebagai halaman utama
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/component/layout_navbar.dart';
import 'package:myapp/presentation/component/app_theme.dart';

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
         theme: AppTheme.lightTheme, // Atur theme jika diperlukan
          home: LayoutNavbar(), 
      ),
     // Menggunakan LayoutNavbar sebagai halaman utama
    );
  }
}

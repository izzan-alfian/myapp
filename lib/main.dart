import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_event.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_event.dart';
import 'package:myapp/presentation/component/layout_navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AttendancesBloc>(
          create: (context) => AttendancesBloc()..add(FetchAttendance(date: DateTime.now())),
        ), 
        BlocProvider<BackdateBloc>(
          create: (context) => BackdateBloc()..add(FetchBackdate(date: DateTime.now())),
        ),
    
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
            displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF33499e),
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            showUnselectedLabels: true,
          ),
        ),
        home: LayoutNavbar(),
      ),
    );
  }
}
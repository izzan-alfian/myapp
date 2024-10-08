import 'package:flutter/material.dart';
import 'package:myapp/presentation/pages/attendances/attendances.dart';
import 'package:myapp/presentation/pages/daily_report/daily_report.dart';
import 'package:myapp/presentation/component/app_theme.dart';

class LayoutNavbar extends StatefulWidget {
  @override
  _LayoutNavbarState createState() => _LayoutNavbarState();
}

class _LayoutNavbarState extends State<LayoutNavbar> {
  int _selectedIndex = 0;

  // List halaman yang akan ditampilkan
  static List<Widget> _pages = <Widget>[
    DashboardPage(),
    AttendancesPage(),
    ProjectTaskPage(),
    DailyReportPage(),
    LogisticsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Attendances',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Project & Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Daily Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Logistics',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Halaman dummy untuk demonstrasi
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf0f0f0),
      appBar: AppBar(
        backgroundColor: Color(0xFFf0f0f0),
        elevation: 0,
        title: Text('Dashboard'),
      ),
    );
  }
}

class ProjectTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf0f0f0),
      appBar: AppBar(
        backgroundColor: Color(0xFF33499e),
        title: Text('Project & Task', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class LogisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf0f0f0),
      appBar: AppBar(
        backgroundColor:Color(0xFF33499e),
        title: Text('Logistics Report', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

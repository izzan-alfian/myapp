// Suggested code may be subject to a license. Learn more: ~LicenseLog:2541630560.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1337891209.
import 'package:flutter/material.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({Key? key}) : super(key: key);

  @override
  State<DailyReport> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Daily Report',
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Handle search functionality here
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Handle filter functionality here
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Daily Report lol'),
      ),
    );
  }
}

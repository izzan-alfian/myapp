// Suggested code may be subject to a license. Learn more: ~LicenseLog:2541630560.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1337891209.
import 'package:flutter/material.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Attendances'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Logic for search action
              },
            ),
            IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () {
                // Logic for filter action
              },
            ),
          ],
        ),
        body: 
          Padding(padding: const EdgeInsets.all(12.0), child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text("Hari/ Tanggal"),
          Text("Hari/ Tanggal"),
          Text("Hari/ Tanggal"),
          Text("Hari/ Tanggal"),
          Text("Hari/ Tanggal"),
          Text("Hari/ Tanggal"),]),
          ));
  }
}

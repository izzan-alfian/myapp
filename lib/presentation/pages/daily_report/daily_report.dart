import 'package:flutter/material.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  @override
  Widget build(BuildContext context) {
    // Dummy data list for placeholder attendances
    final List<Map<String, String>> attendances = [
      {"name": "John Doe", "position": "Manager", "time": "9:00 AM"},
      {"name": "Jane Smith", "position": "Developer", "time": "10:00 AM"},
      {"name": "Alex Johnson", "position": "Designer", "time": "11:00 AM"},
    ];

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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Hari/ Tanggal"),

              // Large TextField
              SizedBox(
                height: 150,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your notes here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // Temporary ListTile with placeholder text
              ListTile(
                title: Text("Employee Name"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Position"),
                    Text("Time"),
                  ],
                ),
                trailing: Icon(Icons.access_time, color: Colors.red),
              ),

              // List of attendance cards with dummy data
              Expanded(
                child: ListView.builder(
                  itemCount: attendances.length,
                  itemBuilder: (context, index) {
                    final attendance = attendances[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(attendance["name"] ?? "Name"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(attendance["position"] ?? "Position"),
                            Text(attendance["time"] ?? "Time"),
                          ],
                        ),
                        trailing: Icon(Icons.access_time, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),

              // Additional Text widgets with placeholder content
              Text("Hari/ Tanggal"),
              Text("Hari/ Tanggal"),
              Text("Hari/ Tanggal"),
              Text("Hari/ Tanggal"),
              Text("Hari/ Tanggal"),
            ],
          ),
        ));
  }
}

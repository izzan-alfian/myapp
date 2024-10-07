import 'package:flutter/material.dart';

class Attendances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Attendances',
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

          //  isLoading
          // ? Center(child: CircularProgressIndicator()) // Menampilkan loading ketika fetch data
          body:
           Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(
                        'Today, ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '25 October 2024',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    // itemCount: attendances.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical:2),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text( 'Name'
                                  // attendances, // Ambil nama dari API
                                  // style: TextStyle(
                                  //   fontWeight: FontWeight.bold,
                                  // ),
                                ),
                                Text( 'Job Position'
                                  // attendances[index]['position'], // Ambil posisi pekerjaan dari API
                                  // style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                              ),
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.access_time,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    
    );
  }
}
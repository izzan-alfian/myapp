import 'package:flutter/material.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  String? dropdownValue = "Ash";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf0f0f0),
        appBar: AppBar(
          backgroundColor: Color(0xFF33499e),
          title: Text('Daily Report',style: TextStyle(color: Colors.white)), 
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hari/ Tanggal"),

                    // Large TextField
                    SizedBox(
                      height: 150, // Adjust this height as needed
                      child: TextField(
                        maxLines: null, // Makes the TextField scrollable
                        expands: true, // Expands to fill the given height
                        decoration: InputDecoration(
                          hintText: 'Enter your notes here...',
                          fillColor: Colors.white, // Background color
                          filled: true, // Enable fill color
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0), // Border color and width
                          ),
                          // Optional: Define what the border looks like when the TextField is focused
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0), // Change color on focus
                          ),
                          // Optional: Define what the border looks like when the TextField is not editable
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Color(0xFFe4e6ed),
                                width: 2.0), // Border color when enabled
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text("Hari/ Tanggal"),

                    SizedBox(
                      height: 150, // Adjust this height as needed
                      child: TextField(
                        maxLines: null, // Makes the TextField scrollable
                        expands: true, // Expands to fill the given height
                        decoration: InputDecoration(
                          hintText: 'Enter your notes here...',
                          fillColor: Colors.white, // Background color
                          filled: true, // Enable fill color
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0), // Border color and width
                          ),
                          // Optional: Define what the border looks like when the TextField is focused
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0), // Change color on focus
                          ),
                          // Optional: Define what the border looks like when the TextField is not editable
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Color(0xFFe4e6ed),
                                width: 2.0), // Border color when enabled
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text("Hari/ Tanggal"),

                    SizedBox(
                      height: 150, // Adjust this height as needed
                      child: TextField(
                        maxLines: null, // Makes the TextField scrollable
                        expands: true, // Expands to fill the given height
                        decoration: InputDecoration(
                          hintText: 'Enter your notes here...',
                          fillColor: Colors.white, // Background color
                          filled: true, // Enable fill color
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                            borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0), // Border color and width
                          ),
                          // Optional: Define what the border looks like when the TextField is focused
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0), // Change color on focus
                          ),
                          // Optional: Define what the border looks like when the TextField is not editable
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Color(0xFFe4e6ed),
                                width: 2.0), // Border color when enabled
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text("Select Option"), // Changed label for clarity
                    DropdownButton<String>(
                      value: dropdownValue,
                      hint: const Text("Select an option"), // Placeholder text
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(child: Text("Ash"), value: "Ash"),
                        DropdownMenuItem(child: Text("Bash"), value: "Bash"),
                        DropdownMenuItem(child: Text("Cash"), value: "Cash"),
                        DropdownMenuItem(child: Text("Dash"), value: "Dash"),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value; // Update the selected value
                        });
                      },
                    ),
                  ]),
            )));
  }
}

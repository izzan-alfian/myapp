import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  String? dropdownValue = "Ash";

  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = DateFormat('yyyy-mm-dd')
        .format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFf0f0f0),
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Daily Report', style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    TextField(
                      controller: dateInput,
                      decoration: InputDecoration(
                        filled: true, // Enable fill color
                        fillColor: Colors.white, // Background color

                        labelText: "Report date",
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-mm-dd').format(pickedDate);
                              setState(() {
                                dateInput.text =
                                    formattedDate; // Set the formatted date in the TextField
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text("Hari/ Tanggal"),

                    IntrinsicHeight(
                      child: TextField(
                        maxLines:
                            null, // Allows unlimited lines and makes the TextField scrollable as needed
                        minLines: 1, // Adjust this to set the initial height
                        decoration: InputDecoration(
                          hintText: 'Enter your notes here...',
                          fillColor: Colors.white, // Background color
                          filled: true, // Enable fill color
                          border: OutlineInputBorder(),
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
                          // Optional: Define what the border looks like when the TextField is focused
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width: 2.0), // Change color on focus
                          ),
                          // Optional: Define what the border looks like when the TextField is not editable
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
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

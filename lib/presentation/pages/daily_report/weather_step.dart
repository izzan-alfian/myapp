import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherStep extends StatefulWidget {
  const WeatherStep({Key? key}) : super(key: key);

  @override
  _WeatherStepState createState() => _WeatherStepState();
}

class _WeatherStepState extends State<WeatherStep> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                )),
          ),
          SizedBox(height: 20),
          IntrinsicHeight(
            child: TextField(
              maxLines: null, // Makes the TextField scrollable
              minLines: 1,
              decoration: InputDecoration(
                labelText: "Optional notes",
                fillColor: Colors.white, // Background color
                filled: true, // Enable fill color
                // Optional: Define what the border looks like when the TextField is focused
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  // Optional: Define what the border looks like when the TextField is not editable
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
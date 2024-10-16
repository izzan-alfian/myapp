import 'package:flutter/material.dart';
import 'dart:ui';

class WeatherStep extends StatefulWidget {
  const WeatherStep({Key? key}) : super(key: key);

  @override
  _WeatherStepState createState() => _WeatherStepState();
}

class _WeatherStepState extends State<WeatherStep> {
  // List to hold the containers
  List<Container> containers = [];
  final ScrollController _scrollController = ScrollController();
  int? selectedWeatherIndex;

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display all containers
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController, // Attach the controller
          child: Row(
            children: [
              ..._buildContainerList(),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: _addContainer,
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),

        ElevatedButton(
          onPressed: _addContainer,
          child: Icon(Icons.add),
        ),

        SizedBox(height: 20),

        // TextField
        IntrinsicHeight(
          child: TextField(
            maxLines: null, // Makes the TextField scrollable
            minLines: 1,
            decoration: InputDecoration(
              labelText: "Optional notes",
              fillColor: Colors.white, // Background color
              filled: true, // Enable fill color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),

      ],
    );
  }

  void _addContainer() {
    setState(() {
      // Add a new container to the list
      containers.add(
        Container(
          width: 100,
          height: 200,
          margin: EdgeInsets.only(top: 10), // Add some space between containers
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("9AM - 5PM"),
              const Text("Weather"),
              GestureDetector(
                child: InkWell(
                  onTap: () {},
                  child: 
                    const Icon(Icons.remove),
                ),
              ),
            ],
          ),
        ),
      );
    });
    
    // Scroll to the right
    _scrollToRight();
  }

  void _scrollToRight() {
    // Check if the controller is attached
    if (_scrollController.hasClients) {
      // Scroll to the right by a fixed amount (e.g., width of a container + spacing)
      _scrollController.animateTo(
        _scrollController.position.pixels + 110, // 100 (width) + 10 (spacing)
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Widget> _buildContainerList() {
    List<Widget> containerList = [];
    for (int i = 0; i < containers.length; i++) {
      containerList.add(containers[i]);
      if (i < containers.length - 1) {
        containerList.add(SizedBox(width: 10.0)); // Add SizedBox between containers
      }
    }
    return containerList;
  }
}

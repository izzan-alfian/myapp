import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';


class WeatherStep extends StatefulWidget {
  const WeatherStep({Key? key}) : super(key: key);

  @override
  _WeatherStepState createState() => _WeatherStepState();
}

class _WeatherStepState extends State<WeatherStep> {
  int touchIndex = -1;
  // List to hold the containers
  List<Container> containers = [];
  List<WeatherDesc> weathers = [];
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
        SizedBox(height: 300,
          child:
            weathers.isEmpty ?
              Center(
                child: ElevatedButton(
                  onPressed: _addContainer,
                  child: Icon(Icons.add),
                ),
              )
            :
              ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: weathers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 300,
                          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0), // Made EdgeInsets const
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(weathers[index].start.format(context), style: TextStyle(color: Colors.grey)),
                                  Text(" - ", style: TextStyle(color: Colors.grey)),
                                  Text(weathers[index].end.format(context), style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Text("${weathers[index].weather}", style: TextStyle(fontSize: 25.0)),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    weathers.removeAt(index); // Removes current item instead of last container
                                  });
                                },
                                child: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      if (index == weathers.length - 1)
                        ElevatedButton(
                          onPressed: _addContainer,
                          child: Icon(Icons.add),
                        ),
                    ],
                  );
                },
              ),


        ),

        SizedBox(height: 20.0,),

        // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //   Transform.scale(
        //     scaleX: -1,
        //     child: SizedBox(   
        //       width: 150.0,
        //       height: 150.0,
        //         child: AspectRatio(
        //         aspectRatio: 1,
        //         child: PieChart(
        //           PieChartData(
        //             sectionsSpace: 0.0,
        //             centerSpaceRadius: 0.0,
        //             startDegreeOffset: -90.0,
        //             borderData: FlBorderData(show: false),
        //             sections: showingSections(),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // SizedBox(   
        //     width: 150.0,
        //     height: 150.0,  
        //       child: AspectRatio(
        //       aspectRatio: 1,
        //       child: PieChart(
        //         PieChartData(
        //           sections: showingSections(),
        //           borderData: FlBorderData(show: false),
        //           centerSpaceRadius: 0.0,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],)

      ],
    );
  }

  // List<PieChartSectionData> showingSections() {
  //   return List.generate(2, (i) {
  //     final isTouched = i == 0; // Example: Highlighting the second section
  //     final double fontSize = isTouched ? 25 : 16;
  //     final double radius = isTouched ? 60 : 50;

  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: Colors.blue,
  //           value: 240,
  //           title: 'B%',
  //           radius: radius,
  //           titleStyle: TextStyle(fontSize: fontSize, color: Colors.white),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: Colors.red,
  //           value: 480,
  //           title: 'R%',
  //           radius: radius,
  //           titleStyle: TextStyle(fontSize: fontSize, color: Colors.white),
  //         );
  //       default:
  //         throw Error();
  //     }
  //   });
  // }

  void _addContainer() {
    setState(() {
      weathers.add(WeatherDesc());
      _scrollToRight();
    });
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

class WeatherDesc {
  String weather;
  TimeOfDay start;
  TimeOfDay end;

  WeatherDesc({
    this.weather = "Sunny",
    TimeOfDay? start,
    this.end = const TimeOfDay(hour: 17, minute: 0),
  }) : start = start ?? TimeOfDay.now();
}


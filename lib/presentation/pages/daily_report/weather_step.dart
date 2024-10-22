import 'package:flutter/material.dart';
import 'dart:ui';

class WeatherStep extends StatefulWidget {
  const WeatherStep({Key? key}) : super(key: key);

  @override
  _WeatherStepState createState() => _WeatherStepState();
}

class _WeatherStepState extends State<WeatherStep> {
  int touchIndex = -1;
  List<WeatherDesc> weathers = [];
  final ScrollController _scrollController = ScrollController();

  List<String> weatherTypes = ["Clear", "Raining", "Cloudy", "Wind", "Drizzle", "Fog", "Snow"];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: weathers.isEmpty
              ? Center(
                  child: ElevatedButton(
                    onPressed: _addContainer,
                    child: Icon(Icons.add),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: weathers.length,
                  itemBuilder: (context, index) {
                    return _buildWeatherContainer(index);
                  },
                ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildWeatherContainer(int index) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0), bottom: Radius.circular(100.0)),
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.more_vert_rounded, color: Colors.grey,),
                  SizedBox(height: 15.0,),
                    _buildTimePicker('Start Time', weathers[index].start, (pickedTime) {
                      setState(() {
                        weathers[index].start = pickedTime;
                      });
                    }),
                ],),

                SizedBox(height: 5.0,),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.subdirectory_arrow_right_rounded, color: Colors.grey),
                  _buildTimePicker('End Time', weathers[index].end, (pickedTime) {
                  setState(() {
                    weathers[index].end = pickedTime;
                  });
                }),
                ],)
              ],),
              Icon(Icons.sunny, size: 50.0),
              _buildWeatherDropdown(index),
              _buildDeleteButton(index),
            ],
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
  }

  Widget _buildTimePicker(String label, TimeOfDay time, Function(TimeOfDay) onTimeSelected) {
    return InkWell(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 100.0,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5 , color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text(time.format(context), style: TextStyle(fontSize: 20.0)),
      ),
    );
  }

  Widget _buildWeatherDropdown(int index) {
    return SizedBox(
      width: 110,
      child: DropdownButtonFormField<String>(
        value: weathers[index].weather,
        decoration: const InputDecoration(
          enabled: true,
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        items: weatherTypes.map((String weather) {
          return DropdownMenuItem<String>(
            value: weather,
            child: Text(weather),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            weathers[index].weather = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildDeleteButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          weathers.removeAt(index);
        });
      },
      child: const Icon(Icons.delete),
    );
  }

  void _addContainer() {
    setState(() {
      weathers.add(WeatherDesc());
      _scrollToRight();
    });
  }

  void _scrollToRight() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.pixels + 160,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

class WeatherDesc {
  String weather;
  TimeOfDay start;
  TimeOfDay end;

  WeatherDesc({
    this.weather = "Clear",
    TimeOfDay? start,
    this.end = const TimeOfDay(hour: 0, minute: 0),
  }) : start = start ?? const TimeOfDay(hour: 24, minute: 0);
}

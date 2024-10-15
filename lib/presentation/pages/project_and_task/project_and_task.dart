import 'package:flutter/material.dart';

class ProjectAndTaskPage extends StatefulWidget {
  @override
  _ProjectAndTaskState createState() => _ProjectAndTaskState();
}

class _ProjectAndTaskState extends State<ProjectAndTaskPage> {
  double _sliderValue = 0.0;

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value; // Update state with slider value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _sliderValue,
          onChanged: _onSliderChanged, // Using ValueChanged
          min: 0,
          max: 100,
        ),
        Text('Slider value: ${_sliderValue.toStringAsFixed(1)}'),
      ],
    );
  }
}

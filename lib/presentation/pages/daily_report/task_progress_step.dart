import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TaskProgressStep extends StatefulWidget {
  TaskProgressStep({super.key});

  @override
  _TaskProgressStepState createState() => _TaskProgressStepState();
}

class _TaskProgressStepState extends State<TaskProgressStep> {
  TextEditingController sliderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Container(
        decoration: BoxDecoration(border: Border.all(color: Color(0xFFb6bdc4)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: ExpansionPanelListExample(),
        ),
      ),

      SizedBox(height: 20.0),

    ],);
  }
}

class ExpansionPanelListExample extends StatefulWidget {
  const ExpansionPanelListExample({super.key});

  @override
  State<ExpansionPanelListExample> createState() =>
      _ExpansionPanelListExampleState();
}

class _ExpansionPanelListExampleState extends State<ExpansionPanelListExample> {
  final List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      dividerColor: const Color(0xFFf0f0f0),
      elevation: 0, // Removes shadow from list
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },  
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          backgroundColor: item.isExpanded ? const Color(0x00000000) : Colors.white,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            bool isSliderModified = item.expandedValue.any((listBuilder) {
              return listBuilder.actualWeight != listBuilder.finalWeight;     // logic behind the yellow dot appearance when slider value is edited
            });
            return ListTile(
              title: Row(
                children: [
                  SizedBox(width: 10.0,),

                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color((0xFFb6bdc4))),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text("${item.expandedValue.length} ", style: TextStyle(color: Color((0xFFb6bdc4))),),
                        Text("tasks", style: TextStyle(color: Color((0xFFb6bdc4)), fontSize: 14.0),),
                      ],)
                      ),
                  ),

                  SizedBox(width: 10.0,),

                  Text("${item.headerValue}  "),

                  if (isSliderModified) const Icon(Icons.circle, size: 7.0, color: Color(0xFFffd166)),
                  ],),
            );
          },
          body: Column(
            children: item.expandedValue.expand((listBuilder) {
              return [
                listBuilder,
                const SizedBox(height: 20.0),
              ];
            }).toList()..removeLast(), // Remove the last SizedBox
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
// A side plan to separate tasks item from their builder
// class Task{
//   String projectName;
//   int progress;
//   DateTime startDate;
//   DateTime endTime;
//   bool isOverdue;
//   int sliderValue;

//   Task({
//     required this.projectName,
//     required this.progress,
//     required this.startDate,
//     required this.endTime,
//     required this.isOverdue,
//   }) : sliderValue = progress;
// }

class Task {
  final String projectName;
  final double plannedWeight;
  final double actualWeight;
  final DateTime startDate;
  final DateTime endTime;
  final bool isOverdue;
  
  Task({
    required this.projectName,
    required this.plannedWeight,
    required this.actualWeight,
    required this.startDate,
    required this.endTime,
    required this.isOverdue,
  });
}

class ListBuilder extends StatefulWidget {
  final String projectName;
  final double plannedWeight;
  final double actualWeight;
  final DateTime startDate;
  final DateTime endTime;
  final bool isOverdue;
  double finalWeight;         // represent final actualWeight

  ListBuilder({
    super.key,
    required this.projectName,
    required this.plannedWeight,
    required this.actualWeight,
    required this.startDate,
    required this.endTime,
    required this.isOverdue,
  }) : finalWeight = actualWeight;

  @override
  _ListBuilderState createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  double initProgressValue = 0;
  double _currentSliderValue = 0; //temporarily set to 0 because flutter require the top variable to be initialized, but this variable's value will definitely determined in initState()
  TextEditingController percentageTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initProgressValue = widget.actualWeight / widget.plannedWeight * 100; // Permanent initial progress representation
    _currentSliderValue = initProgressValue;                        // Editable slider value
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: 105,
        width: screenWidth - 52.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: getActiveColor(initProgressValue, _currentSliderValue), width: 5.0),
            top: BorderSide(color: getActiveColor(initProgressValue, _currentSliderValue), width: 2.0),
            right: BorderSide(color: getActiveColor(initProgressValue, _currentSliderValue), width: 2.0),
            bottom: BorderSide(color: getActiveColor(initProgressValue, _currentSliderValue), width: 2.0)
            ),
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child:
                          Text("• ${widget.projectName}",
                            style: const TextStyle(color: Color(0xFF363537), fontSize: 18.0)),),
                          widget.isOverdue ?
                            const Text("Overdue •",
                              style:TextStyle(color: Colors.redAccent, fontSize: 18.0, fontWeight: FontWeight.w600),) :
                            const Text("")
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child:
                          SizedBox(
                            height: 20,
                            child: SliderTheme(
                              data: SliderThemeData(
                                // trackShape: CustomTrackShape(),
                                // thumbShape: const CustomSliderThumbShape(),
                                // overlayShape: const CustomSliderOverlayShape(),
                              ),
                              child: Slider(
                                value: _currentSliderValue.toDouble(),
                                max: 100,
                                min: 0,
                                activeColor: getActiveColor(initProgressValue, _currentSliderValue),
                                inactiveColor: Colors.grey,
                                thumbColor: getActiveColor(initProgressValue, _currentSliderValue),
                                label: _currentSliderValue.round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    if (value > initProgressValue) {
                                      _currentSliderValue = double.parse(value.toStringAsFixed(4));
                                      widget.finalWeight = double.parse(value.toStringAsFixed(4)) / 100.0 * widget.plannedWeight;
                                    }
                                    else {
                                      _currentSliderValue = widget.actualWeight / widget.plannedWeight * 100.0;
                                      widget.finalWeight = widget.actualWeight / widget.plannedWeight * widget.plannedWeight;
                                    }
                                    percentageTextController.text = _currentSliderValue.toStringAsFixed(4);
                                    weightTextController.text = widget.finalWeight.toStringAsFixed(4);
                                  });
                                },
                              ),
                            ),
                          )
                      ),

                      const SizedBox(width: 10.0,height: 30.0,),
                      
                      SizedBox(
                        width: 80,
                        height: 20,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: percentageTextController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _currentSliderValue.toStringAsFixed(4),
                          ),
                          onSubmitted: (text) {
                            setState(() {
                              double? value = double.tryParse(text);
                              if (value != null) {
                                if      (value < initProgressValue) {value = initProgressValue;}
                                else if (value > 100.0)             {value = 100.0;}
                                _currentSliderValue = value;
                                percentageTextController.text = _currentSliderValue.toStringAsFixed(4);
                                widget.finalWeight = _currentSliderValue / 100.0 * widget.plannedWeight;
                                weightTextController.text = widget.finalWeight.toStringAsFixed(4);
                              }
                            });
                          },
                        ),
                      ),

                      const Text("%"),

                    ],
                  ),

                  Row( children: [
                    Expanded(child: Row(children: [
                      Text(intl.DateFormat('dd MMM yyyy').format(widget.startDate), style: const TextStyle(color: Colors.grey, fontSize: 10.0),),
                      const Text(" - "                                                  , style: TextStyle(color: Colors.grey, fontSize: 10.0),),
                      Text(intl.DateFormat('dd MMM yyyy').format(widget.startDate), style: const TextStyle(color: Colors.grey, fontSize: 10.0),)
                    ],)),

                    Text("${widget.actualWeight} → ", style: const TextStyle(color: Colors.grey, fontSize: 12.0),),
                    
                    SizedBox(
                      width: 60,
                      height: 20,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: weightTextController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.finalWeight.toString(),
                        ),
                        onSubmitted: (text) {
                          setState(() {
                            double? value = double.tryParse(text);
                            if (value != null) {
                                if      (value <= widget.actualWeight) {value = widget.actualWeight;}
                                else if (value > widget.plannedWeight) {value = widget.plannedWeight;}
                                _currentSliderValue = value / widget.plannedWeight * 100;
                                weightTextController.text = value.toStringAsFixed(4);
                                percentageTextController.text = _currentSliderValue.toStringAsFixed(4);
                                widget.finalWeight = _currentSliderValue / 100.0 * widget.plannedWeight;
                              }
                          });
                        },
                      ),
                    ),

                    Text("/${widget.plannedWeight}", style: const TextStyle(color: Colors.grey, fontSize: 10.0),),

                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String headerValue;
  List<ListBuilder> expandedValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfCategory) {
  return List<Item>.generate(numberOfCategory, (int categoryIndex) {
    return Item(
      headerValue: 'Panel $categoryIndex',
      expandedValue: generateTasks(2),
    );
  });
}

List<ListBuilder> generateTasks(int numberOfTask) {
  return List<ListBuilder>.generate(numberOfTask, (int categoryIndex) {
    return ListBuilder(
      projectName: "自転車を準備する",
      plannedWeight: 0.08,
      actualWeight: 0.04,
      startDate: DateTime.now(),
      endTime: DateTime.now(),
      isOverdue: true,
    );
  });
}


Color getActiveColor(double initProgress, double currentSliderValue) {
  if (currentSliderValue <= initProgress) {
    return const Color(0xFFb6bdc4);
  } else {
    return const Color(0xFFffd166);
  }
}

// class CustomTrackShape extends RoundedRectSliderTrackShape {
//   @override
//   Rect getPreferredRect({
//     required RenderBox parentBox,
//     Offset offset = Offset.zero,
//     required SliderThemeData sliderTheme,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//   }) {
//     final trackHeight = sliderTheme.trackHeight;
//     final trackLeft = offset.dx;
//     final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
//     final trackWidth = parentBox.size.width;
//     return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
//   }
// }

// class CustomSliderThumbShape extends RoundSliderThumbShape {
//   const CustomSliderThumbShape({super.enabledThumbRadius = 10.0});

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     super.paint(context,
//         center.translate(-(value - 0.5) / 0.5 * enabledThumbRadius, 0.0),
//         activationAnimation: activationAnimation,
//         enableAnimation: enableAnimation,
//         isDiscrete: isDiscrete,
//         labelPainter: labelPainter,
//         parentBox: parentBox,
//         sliderTheme: sliderTheme,
//         textDirection: textDirection,
//         value: value,
//         textScaleFactor: textScaleFactor,
//         sizeWithOverflow: sizeWithOverflow);
//   }
// }

// class CustomSliderOverlayShape extends RoundSliderOverlayShape {
//   final double thumbRadius;
//   const CustomSliderOverlayShape({this.thumbRadius = 10.0});

//   @override
//   void paint(
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   }) {
//     super.paint(
//         context, center.translate(-(value - 0.5) / 0.5 * thumbRadius, 0.0),
//         activationAnimation: activationAnimation,
//         enableAnimation: enableAnimation,
//         isDiscrete: isDiscrete,
//         labelPainter: labelPainter,
//         parentBox: parentBox,
//         sliderTheme: sliderTheme,
//         textDirection: textDirection,
//         value: value,
//         textScaleFactor: textScaleFactor,
//         sizeWithOverflow: sizeWithOverflow);
//   }
// }
import 'package:flutter/material.dart';

class TaskProgressStep extends StatefulWidget {
  const TaskProgressStep({Key? key}) : super(key: key);

  @override
  _TaskProgressStepState createState() => _TaskProgressStepState();
}

class _TaskProgressStepState extends State<TaskProgressStep> {
  int _currentSliderValue = 75;
  TextEditingController sliderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      ListBuilder(),

      SizedBox(height: 40.0),

      ExpansionPanelListExample()

    ],);
  }
}

class ListBuilder extends StatefulWidget {

  @override
  _ListBuilderState createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  final int initValue = 50;
  int _currentSliderValue = 0; //temporarily set to 0 because flutter require the top variable to be initialized, but this variable's value will definitely determined in initState()
  TextEditingController sliderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSliderValue = initValue;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
    children: [
      Container(
        height: 105,
        width: screenWidth,
        decoration: BoxDecoration(
          color: getActiveColor(_currentSliderValue),
          border: Border.all(color: getActiveColor(_currentSliderValue), width: 2.0),
          borderRadius: BorderRadius.circular(15.0)
        ),
      ),
      Positioned(
        right: 0,
        child: Container(
          height: 105,
          width: screenWidth - 52.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: getActiveColor(_currentSliderValue), width: 2.0),
            borderRadius: BorderRadius.circular(15.0)
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  children: [

                    Row(
                      children: [
                        Expanded(child: Text("• 自転車を準備する",   style: TextStyle(color: Color(0xFF363537),  fontSize: 18.0)),),
                                        Text("Overdue •", style: TextStyle(color: Colors.redAccent,             fontSize: 18.0, fontWeight: FontWeight.w600),)
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
                                  trackShape: CustomTrackShape(),
                                  thumbShape: CustomSliderThumbShape(),
                                  overlayShape: CustomSliderOverlayShape(),
                                ),
                                child: Slider(
                                  value: _currentSliderValue.toDouble(),
                                  max: 100,
                                  min: 0,
                                  activeColor: getActiveColor(_currentSliderValue),
                                  inactiveColor: Colors.grey,
                                  thumbColor: getActiveColor(_currentSliderValue),
                                  label: _currentSliderValue.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      if (value > initValue) {
                                        _currentSliderValue = value.toInt();
                                        sliderController.text = _currentSliderValue.toString();
                                      }
                                    });
                                  },
                                ),
                              ),
                            )
                        ),

                        SizedBox(width: 10.0,height: 30.0,),
                        
                        SizedBox(
                          width: 33,
                          height: 20,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: sliderController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: _currentSliderValue.toString(),
                            ),
                            onSubmitted: (text) {
                              setState(() {
                                int? value = int.tryParse(text);
                                if (value != null) {
                                  if (value < initValue) {
                                    _currentSliderValue = initValue;
                                  } else if (value > 100) {
                                    _currentSliderValue = 100;
                                  } else {
                                    _currentSliderValue = value;
                                  }
                                  sliderController.text = _currentSliderValue.toString(); // Sync text field with slider value
                                  sliderController.selection = TextSelection.fromPosition(TextPosition(offset: sliderController.text.length)); // Move cursor to end
                                }
                              });
                            },
                          ),
                        ),

                        Text("%"),

                      ],
                    ),

                    Row(
                      children: [
                        Expanded(child: Text("10 Sep 2024 - 12 Oct 2024", style: TextStyle(color: Colors.grey, fontSize: 10.0),),),
                                        Text("View More",                 style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),),
                                        Icon(Icons.keyboard_arrow_down, color: Colors.blueAccent)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    ],
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
  Widget expandedValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: ListBuilder(),
    );
  });
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
      elevation: 0, // Removes shadow from each list
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          backgroundColor: item.isExpanded ? Color(0x00) : Colors.white,
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Row(
                children: [
                  Text("${item.headerValue}  "),
                  Icon(Icons.circle, size: 7.0, color: Color(0xFFffd166))
                  ],),
            );
          },
          body: item.expandedValue,
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}


Color getActiveColor(int currentSliderValue) {
  if (currentSliderValue <= 50) {
    return Color(0xFFb6bdc4);
  } else {
    return Color(0xFFffd166);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  const CustomSliderThumbShape({super.enabledThumbRadius = 10.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(context,
        center.translate(-(value - 0.5) / 0.5 * enabledThumbRadius, 0.0),
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow);
  }
}

class CustomSliderOverlayShape extends RoundSliderOverlayShape {
  final double thumbRadius;
  const CustomSliderOverlayShape({this.thumbRadius = 10.0});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
        context, center.translate(-(value - 0.5) / 0.5 * thumbRadius, 0.0),
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow);
  }
}
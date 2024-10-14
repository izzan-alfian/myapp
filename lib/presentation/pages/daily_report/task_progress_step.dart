import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_bloc.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_event.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_state.dart';
import 'package:myapp/data/repositories/planner_consultant_repository_impl.dart';
import 'package:myapp/data/repositories/project_repository_impl.dart';
import 'package:myapp/data/repositories/service_provider_repository_impl.dart';
import 'package:myapp/data/repositories/supervisor_consultant_repository_impl.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(children: [

      // Container(
      //   decoration: BoxDecoration(
      //     border: Border.all(width: 1), borderRadius: BorderRadius.all(Radius.circular(10)),
      //   ),
      //   child: Table(
      //   border: TableBorder.symmetric(
      //     inside: BorderSide(width: 1),
      //   ),
      //   columnWidths: const <int, TableColumnWidth>{
      //     0: IntrinsicColumnWidth(),
      //     1: FlexColumnWidth(),
      //     2: FixedColumnWidth(64),
      //   },
      //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      //   children: <TableRow>[
      //     TableRow(
      //       children: <Widget>[
      //         Container(
      //           height: 32,
      //           color: Colors.green,
      //         ),
      //         TableCell(
      //           verticalAlignment: TableCellVerticalAlignment.top,
      //           child: Container(
      //             height: 32,
      //             width: 32,
      //             color: Colors.red,
      //           ),
      //         ),
      //         Container(
      //           height: 64,
      //           color: Colors.blue,
      //         ),
      //       ],
      //     ),
      //     TableRow(
      //       decoration: const BoxDecoration(
      //         color: Colors.grey,
      //       ),
      //       children: <Widget>[
      //         Container(
      //           height: 64,
      //           width: 128,
      //           color: Colors.purple,
      //         ),
      //         Container(
      //           height: 32,
      //           color: Colors.yellow,
      //         ),
      //         Center(
      //           child: Container(
      //             height: 32,
      //             width: 32,
      //             color: Colors.orange,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      //   ),
      // ),

      // SizedBox(height: 20.0,),

      Stack(
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
                                          if (value > 50) {
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
                                      if (value < 50) {
                                        _currentSliderValue = 50;
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
                            Expanded(child: Text("10 Sep 2024 - 12 Oct 2024", style: TextStyle(color: Colors.grey,        fontSize: 10.0),),),
                                            Text("View More",                             style: TextStyle(color: Colors.blueAccent,   fontWeight: FontWeight.w600),),
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
      ),

      SizedBox(height: 40.0),


      ExpansionPanelListExample()

      
      // DataTable(
      //   border: const TableBorder(verticalInside: BorderSide(color: Colors.grey, width: 0.5),),
      //   headingRowHeight: 35.0, 
      //   columnSpacing: 20.0,
      //   clipBehavior: Clip.hardEdge,
      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1.0, color: Colors.grey), color: Colors.white),
      //   columns: const <DataColumn>[
      //     DataColumn(
      //       label: Expanded(
      //         child: Text(
      //           'Task',
      //           style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      //         ),
      //       ),
      //     ),
      //     DataColumn(
      //       numeric: true,
      //       label: Expanded(
      //         child: Text(
      //           'Planned w.',
      //           style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      //         ),
      //       ),
      //     ),
      //     DataColumn(
      //       numeric: true,
      //       label: Expanded(
      //         child: Text(
      //           'Prog. (%)',
      //           style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      //         ),
      //       ),
      //     ),
      //   ],
      //   rows: const <DataRow>[
      //     DataRow(
      //       cells: <DataCell>[
      //         DataCell(Text("asd")),
      //         DataCell(Text('0.018')),
      //         DataCell(Text('23%'), showEditIcon: true),
      //       ],
      //     ),
      //     DataRow(
      //       cells: <DataCell>[
      //         DataCell(Text('Task 2')),
      //         DataCell(Text('0.195')),
      //         DataCell(Text('55%'), showEditIcon: true),
      //       ],
      //     ),
      //     DataRow(
      //       cells: <DataCell>[
      //         DataCell(Text('Task 3')),
      //         DataCell(Text('0.247')),
      //         DataCell(Text('78%'), showEditIcon: true),
      //       ],  
      //     ),
      //   ],
      // ),

      
      // BlocProvider(
      //   create: (context) => DailyReportBloc(
      //     projectRepository: ProjectRepositoryImpl(),
      //     serviceProviderRepository: ServiceProviderRepositoryImpl(),
      //     supervisorConsultantRepository: SupervisorConsultantRepositoryImpl(),
      //     plannerConsultantRepository: PlannerConsultantRepositoryImpl(),
      //   )..add(FetchDailyReportData()),
      //   child: BlocBuilder<DailyReportBloc, DailyReportState>(
      //     builder: (context, state) {
      //       if (state is DailyReportLoading) {
      //         return Center(child: CircularProgressIndicator());
      //       } else if (state is DailyReportLoaded) {
      //         return Column(
      //           children: [
      //             _buildListSection("Projects", state.projects),
      //             _buildListSection("Service Providers", state.serviceProviders),
      //             _buildListSection("Supervisor Consultants", state.supervisorConsultants),
      //             _buildListSection("Planner Consultants", state.plannerConsultants),
      //           ],
      //         );
      //       } else if (state is DailyReportError) {
      //         return Center(child: Text(state.message));
      //       } else {
      //         return Container();
      //       }
      //     },
      //   ),
      // ),

    ],);
  }

  // Widget _buildListSection(String title, List<String> items) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(
  //           title,
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       ...items.map((item) => ListTile(title: Text(item))).toList(),
  //     ],
  //   );
  // }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
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
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _data.removeWhere((Item currentItem) => item == currentItem);
                });
              }),
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
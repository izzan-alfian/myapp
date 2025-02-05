import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './task_progress_step.dart';
import './project_select_step.dart';
import './weather_step.dart';
import './documentation_step.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  String? dropdownValue = "Ash";
  int _step = 0;
  final TextEditingController dateInput = TextEditingController();

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
        body: Stepper(
          type: StepperType.horizontal,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: <Widget>[
                TextButton(
                  onPressed: details.onStepContinue,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    (_step == 3) ? 'SEND' : "NEXT",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (_step > 0) // Show CANCEL only if the current step is greater than 0
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('BACK', style: TextStyle(color: Colors.blueAccent),),
                  ),
              ],
            );
          },
          currentStep: _step,
          onStepCancel: () {
            if (_step > 0) {
              setState(() {
                _step -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_step <= 2) {
              setState(() {
                _step += 1;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _step = index;
            });
          },
          steps: <Step>[
            Step(
                title: _step == 0 ? const Text('Project select') : const Text(''),
                isActive: true,
                content: ProjectSelectStep()
                ),
            Step(
              title: _step == 1 ? const Text('Task progress') : const Text(''),
              isActive: _step >= 1,
              content: TaskProgressStep(),
            ),
            Step(
              title: _step == 2 ? const Text('Weather') : const Text(''),
              isActive: _step >= 2,
              content: WeatherStep(),
            ),
            Step(
              title: _step == 3 ? const Text('Documentation') : const Text(''),
              isActive: _step >= 3,
              content: DocumentationStep(),
            )
          ],
        ));
  }
}

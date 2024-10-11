import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_bloc.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_event.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_state.dart';
import 'package:myapp/data/repositories/planner_consultant_repository_impl.dart';
import 'package:myapp/data/repositories/project_repository_impl.dart';
import 'package:myapp/data/repositories/service_provider_repository_impl.dart';
import 'package:myapp/data/repositories/supervisor_consultant_repository_impl.dart';
import 'package:myapp/presentation/pages/daily_report/task_progress_step.dart';

import './project_select_step.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  String? dropdownValue = "Ash";
  int _step = 0;
  final TextEditingController dateInput = TextEditingController();
  final TextEditingController _smpkNo = TextEditingController(text: null);
  final TextEditingController _kontrakNo = TextEditingController(text: null);

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
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (_step >
                    0) // Show CANCEL only if the current step is greater than 0
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('BACK'),
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
            if (_step <= 1) {
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
              content: Column(
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
            ),
          ],
        ));
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) => ListTile(title: Text(item))).toList(),
      ],
    );
  }
}

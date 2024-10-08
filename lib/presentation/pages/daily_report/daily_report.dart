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
                title:
                    _step == 0 ? const Text('Select project') : const Text(''),
                isActive: true,
                content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: dateInput,
                        decoration: InputDecoration(
                          filled: true, // Enable fill color
                          fillColor: Colors.white, // Background color
                          labelText: "Report date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-mm-dd').format(pickedDate);
                                setState(() {
                                  dateInput.text =
                                      formattedDate; // Set the formatted date in the TextField
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: InputDecoration(
                          labelText: 'Project name',
                          filled: true,
                          fillColor: Colors.white, // Background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: <String>['Ash', 'Bash', 'Cash', 'Dash']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),

                      SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: InputDecoration(
                          labelText: 'Service Provider',
                          enabled: true,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: <String>['Ash', 'Bash', 'Cash', 'Dash']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),

                      SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: InputDecoration(
                          labelText: 'Supervisor Consultant',
                          enabled: true,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: <String>['Ash', 'Bash', 'Cash', 'Dash']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),

                      SizedBox(height: 10.0),

                      DropdownButtonFormField<String>(
                        value: null,
                        decoration: InputDecoration(
                          labelText: 'Planner Consultant',
                          enabled: true,
                          filled: true,
                          fillColor: Colors.white, // Background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: <String>['Ash', 'Bash', 'Cash', 'Dash']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),

                      SizedBox(height: 20.0),

                      TextField(
                        controller: _kontrakNo,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "Kontrak No. Tanggal",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0),

                      TextField(
                        controller: _smpkNo,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "SMPK No. Tanggal",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0),

                      // IntrinsicHeight(
                      //   child: TextField(
                      //     maxLines:
                      //         null, // Allows unlimited lines and makes the TextField scrollable as needed
                      //     minLines: 1, // Adjust this to set the initial height
                      //     decoration: InputDecoration(
                      //       labelText: "Project",
                      //       hintText: 'Enter your notes here...',
                      //       fillColor: Colors.white, // Background color
                      //       filled: true, // Enable fill color
                      //       border: OutlineInputBorder(),
                      //     ),
                      //   ),
                      // ),
                    ])),
            Step(
              title: _step == 1 ? const Text('Task progress') : const Text(''),
              isActive: _step >= 1,
              content: BlocProvider(
                create: (context) => DailyReportBloc(
                  projectRepository: ProjectRepositoryImpl(),
                  serviceProviderRepository: ServiceProviderRepositoryImpl(),
                  supervisorConsultantRepository: SupervisorConsultantRepositoryImpl(),
                  plannerConsultantRepository: PlannerConsultantRepositoryImpl(),
                )..add(FetchDailyReportData()),
                child: BlocBuilder<DailyReportBloc, DailyReportState>(
                  builder: (context, state) {
                    if (state is DailyReportLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is DailyReportLoaded) {
                      return Column(
                        children: [
                          _buildListSection("Projects", state.projects),
                          _buildListSection("Service Providers", state.serviceProviders),
                          _buildListSection("Supervisor Consultants", state.supervisorConsultants),
                          _buildListSection("Planner Consultants", state.plannerConsultants),
                        ],
                      );
                    } else if (state is DailyReportError) {
                      return Center(child: Text(state.message));
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
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

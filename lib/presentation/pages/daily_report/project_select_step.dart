import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_bloc.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_event.dart';
import 'package:myapp/presentation/blocs/daily_report/daily_report_state.dart';
import 'package:myapp/data/repositories/planner_consultant_repository_impl.dart';
import 'package:myapp/data/repositories/project_repository_impl.dart';
import 'package:myapp/data/repositories/service_provider_repository_impl.dart';
import 'package:myapp/data/repositories/supervisor_consultant_repository_impl.dart';

class ProjectSelectStep extends StatefulWidget {
  const ProjectSelectStep({Key? key}) : super(key: key);

  @override
  _ProjectSelectStepState createState() => _ProjectSelectStepState();
}

class _ProjectSelectStepState extends State<ProjectSelectStep> {
  String? dropdownValue = "";
  final TextEditingController dateInput = TextEditingController();
  final TextEditingController _smpkNo = TextEditingController(text: null);
  final TextEditingController _kontrakNo = TextEditingController(text: null);

  @override
  void initState() {
    dateInput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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

        BlocProvider(
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
                return Column( children: [


                  DropdownButtonFormField<String>(
                    value: null, //set to value: dropdownvalue in order to set default value
                    decoration: InputDecoration(
                      labelText: 'Project name',
                      enabled: false,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: state.projects
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: null,
                    // onChanged: (String? newValue) {
                    //   setState(() {
                    //     dropdownValue = newValue!;
                    //   });
                    // },
                  ),


                  SizedBox(height: 20),


                  DropdownButtonFormField<String>(
                    value: null, //set to value: dropdownvalue in order to set default value
                    decoration: InputDecoration(
                      labelText: 'Service Provider',
                      enabled: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: state.serviceProviders
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
                    value: null, //set to value: dropdownvalue in order to set default value
                    decoration: InputDecoration(
                      labelText: 'Supervisor Consultant',
                      enabled: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: state.supervisorConsultants
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
                    value: null, //set to value: dropdownvalue in order to set default value
                    decoration: InputDecoration(
                      labelText: 'Planner Consultant',
                      enabled: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: state.plannerConsultants
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


                ],);
              } else if (state is DailyReportError) {
                return Center(child: Text(state.message));
              } else {
                return Container();
              }
            },
          ),
        ),
      ]);
  }
}

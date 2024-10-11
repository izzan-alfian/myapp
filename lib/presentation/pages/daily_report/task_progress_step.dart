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

class TaskProgressStep extends StatefulWidget {
  const TaskProgressStep({Key? key}) : super(key: key);

  @override
  _TaskProgressStepState createState() => _TaskProgressStepState();
}

class _TaskProgressStepState extends State<TaskProgressStep> {
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
    return Column(children: [

      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1), borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(width: 1),
        ),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(64),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Container(
                height: 32,
                color: Colors.green,
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Container(
                  height: 32,
                  width: 32,
                  color: Colors.red,
                ),
              ),
              Container(
                height: 64,
                color: Colors.blue,
              ),
            ],
          ),
          TableRow(
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            children: <Widget>[
              Container(
                height: 64,
                width: 128,
                color: Colors.purple,
              ),
              Container(
                height: 32,
                color: Colors.yellow,
              ),
              Center(
                child: Container(
                  height: 32,
                  width: 32,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
        ),
      ),
      SizedBox(height: 20.0,),

      
      DataTable(
        border: const TableBorder(verticalInside: BorderSide(color: Colors.grey, width: 0.5),),
        headingRowHeight: 35.0, 
        columnSpacing: 20.0,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1.0, color: Colors.grey), color: Colors.white),
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'Task',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ),
          DataColumn(
            numeric: true,
            label: Expanded(
              child: Text(
                'Planned w.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ),
          DataColumn(
            numeric: true,
            label: Expanded(
              child: Text(
                'Prog. (%)',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text("asd")),
              DataCell(Text('0.018')),
              DataCell(Text('23%'), showEditIcon: true),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Task 2')),
              DataCell(Text('0.195')),
              DataCell(Text('55%'), showEditIcon: true),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Task 3')),
              DataCell(Text('0.247')),
              DataCell(Text('78%'), showEditIcon: true),
            ],  
          ),
        ],
      ),

      
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

    ],);
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
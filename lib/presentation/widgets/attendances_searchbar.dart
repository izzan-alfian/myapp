import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_bloc.dart';
import 'package:myapp/presentation/blocs/attendances/attendances_state.dart';
import 'package:myapp/presentation/widgets/attendance_item.dart';

class AttendanceSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Menghapus input query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Menutup search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<AttendancesBloc, AttendancesState>(
      builder: (context, state) {
        if (state is AttendanceLoaded) {
          final results = state.attendances
              .where((attendance) =>
                  attendance.name.toLowerCase().contains(query.toLowerCase()) ||
                  attendance.position
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final attendance = results[index];
              return AttendanceItem(attendance: attendance);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<AttendancesBloc, AttendancesState>(
      builder: (context, state) {
        if (state is AttendanceLoaded) {
          final suggestions = state.attendances
              .where((attendance) =>
                  attendance.name.toLowerCase().contains(query.toLowerCase()) ||
                  attendance.position
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final attendance = suggestions[index];
              return ListTile(
                title: Text(attendance.name),
                subtitle: Text(attendance.position),
                onTap: () {
                  query = attendance.name; // Set query saat item di-tap
                  showResults(context); // Tampilkan hasil
                },
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_bloc.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_state.dart';
import 'package:myapp/presentation/widgets/backdate/backdate_item.dart';

class BackdateSearchDelegate extends SearchDelegate {
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
    return BlocBuilder<BackdateBloc, BackdateState>(
      builder: (context, state) {
        if (state is BackdateLoaded) {
          final results = state.allBackDate
              .where((backdate) =>
                  backdate.name.toLowerCase().contains(query.toLowerCase()) ||
                  backdate.position
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final backdate = results[index];
              return BackdateItem(
                backdate: backdate,
                selectedCheckInTime: null, // Atau berikan waktu check-in yang sesuai
                selectedCheckOutTime: null, // Atau berikan waktu check-out yang sesuai
              );
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
    return BlocBuilder<BackdateBloc, BackdateState>(
      builder: (context, state) {
        if (state is BackdateLoaded) {
          final suggestions = state.allBackDate
              .where((backdate) =>
                  backdate.name.toLowerCase().contains(query.toLowerCase()) ||
                  backdate.position
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final backdate = suggestions[index];
              return ListTile(
                title: Text(backdate.name),
                subtitle: Text(backdate.position),
                onTap: () {
                  query = backdate.name; // Set query saat item di-tap
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

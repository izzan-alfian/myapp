import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/back_date_model.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_event.dart';
import 'package:myapp/presentation/blocs/backdate/backdate_state.dart';

class BackdateBloc extends Bloc<BackdateEvent, BackdateState> {
  List<BackDate> allBackDate = [];

  BackdateBloc() : super(BackDateLoading()) {
    on<FetchBackdate>(_onFetchBackdate);
    // on<FilterBackdateEvent>(_onFilterBackdate);
    // on<UpdateBackdateStatus>(_onUpdateBackdateStatus);
  }

  void _onFetchBackdate(FetchBackdate event, Emitter<BackdateState> emit) {
    try {
      // Dummy data attendances
      allBackDate = [
        BackDate(name: "Dinda Juliana", position: "ABC"),
        BackDate(
            name: "John Doe",
            position: "Supervisor",
            checkIn: DateTime.now().subtract(Duration(days: 1)),
            checkOut: DateTime.now().subtract(Duration(days: 1))),
        BackDate(name: "Jane Smith", position: "Project Manager"),
        BackDate(name: "John Wick", position: "Manpower"),
        BackDate(name: "Michael Johnson", position: "Manager"),
        BackDate(name: "Emily Davis", position: "Manpower"),
        BackDate(name: "Robert Brown", position: "Software Enngineer"),
        BackDate(name: "Sophia Wilso", position: "Product Manager"),
        BackDate(name: "Lucas Taylor", position: "Marketing Manager"),
      ];
      emit(BackdateLoaded(allBackDate));
    } catch (e) {
      emit(BackdateError("Failed to fetch data"));
    }
  }
}

// void _onFilterBackdate(FilterBackdateEvent event, Emitter<BackdateState> emit) {
//   if (state is BackdateLoaded) {
//     List<BackDate> filteredBackdate = allBackDate;

//     // Debugging: Print semua attendances sebelum filter
//     print("All backdate: ");
//     for (var a in allBackDate) {
//       print("checkIn: ${a.checkIn}, checkOut: ${a.checkOut}");
//     }

//     if (event.filter == 'Non-checked') {
//       filteredBackdate =
//           filteredBackdate.where((a) => a.checkIn == null).toList();
//     } else if (event.filter == 'Checked in') {
//       filteredBackdate = filteredBackdate.where((a) {
//         if (a.checkIn == null) return false; // Jika belum pernah check in
//         if (a.checkOut == null)
//           return true; // Sudah check in tapi belum check out

//         // Logika tambahan: Periksa apakah check-in terakhir adalah yang paling baru
//         return a.checkIn!.isAfter(a
//             .checkOut!); // Tetap di "Checked in" jika check-in terbaru lebih lambat dari check-out terakhir
//       }).toList();
//     } else if (event.filter == 'Checked out') {
//       filteredBackdate = filteredBackdate
//           .where((a) =>
//                   a.checkOut != null &&
//                   a.checkIn != null &&
//                   a.checkIn!.isBefore(a
//                       .checkOut!) // Terfilter di "Checked out" jika check-in sebelum check-out
//               )
//           .toList();
//     }

//     // Debugging: Print hasil filter
//     print("Filtered attendances: ");
//     for (var a in filteredBackdate) {
//       print("checkIn: ${a.checkIn}, checkOut: ${a.checkOut}");
//     }

//     emit(BackdateLoaded(filteredBackdate));
//   }
// }

// void _onUpdateBackdateStatus(
//     UpdateBackdateStatus event, Emitter<BackdateState> emit) {
//   final index = allBackDate.indexWhere((a) => a.name == event.name);
//   if (index != -1) {
//     final backdate = allBackDate[index];
//     if (event.isCheckIn) {
//       // Always update checkIn time for a new check-in
//       allBackDate[index] = backdate.copyWith(checkIn: DateTime.now());
//     } else {
//       // Update checkOut time
//       allBackDate[index] = backdate.copyWith(checkOut: DateTime.now());
//     }
//     emit(BackdateLoaded(List.from(allBackDate)));
//   }
// }

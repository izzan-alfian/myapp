import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/data/models/back_date_model.dart';

// Event untuk Backdate
abstract class BackdateEvent extends Equatable {
  const BackdateEvent();
}

class UpdateBackdateStatus extends BackdateEvent {
  final String name;
  final DateTime selectedDateTime;
  final bool isCheckIn;

  UpdateBackdateStatus(this.name, this.selectedDateTime, {required this.isCheckIn});

  @override
  List<Object?> get props => [name, selectedDateTime, isCheckIn];
}

// State untuk Backdate
abstract class BackdateState extends Equatable {
  const BackdateState();
}

class BackdateInitial extends BackdateState {
  @override
  List<Object?> get props => [];
}

class BackdateUpdated extends BackdateState {
  final List<BackDate> updatedBackdates;

  BackdateUpdated(this.updatedBackdates);

  @override
  List<Object?> get props => [updatedBackdates];
}

// Bloc untuk meng-handle backdate event dan state
class BackdateBloc extends Bloc<BackdateEvent, BackdateState> {
  List<BackDate> backdates = []; // Ini daftar backdate yang tersedia

  BackdateBloc() : super(BackdateInitial()) {
    on<UpdateBackdateStatus>((event, emit) {
      // Logic untuk memperbarui check-in/check-out berdasarkan event
      List<BackDate> updatedBackdates = backdates.map((backdate) {
        if (backdate.name == event.name) {
          if (event.isCheckIn) {
            return backdate.copyWith(checkIn: event.selectedDateTime);
          } else {
            return backdate.copyWith(checkOut: event.selectedDateTime);
          }
        }
        return backdate;
      }).toList();

      // Emit state baru dengan daftar yang telah diperbarui
      emit(BackdateUpdated(updatedBackdates));
    });
  }
}

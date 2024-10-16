import 'package:myapp/data/models/back_date_model.dart';

abstract class BackdateState{}

class BackDateLoading extends BackdateState {}

class BackdateLoaded extends BackdateState {
  final List<BackDate> allBackDate;
  
  BackdateLoaded(this.allBackDate);
}

class BackdateError extends BackdateState {
  final String message;
  
  BackdateError(this.message);
}


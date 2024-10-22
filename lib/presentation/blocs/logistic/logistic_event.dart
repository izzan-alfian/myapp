import 'package:equatable/equatable.dart';

// Event Base Class
abstract class LogisticEvent extends Equatable {
  const LogisticEvent();
}

// Event untuk toggle antara material dan equipment
class ToggleLogisticType extends LogisticEvent {
  final bool isMaterialSelected;

  const ToggleLogisticType(this.isMaterialSelected);

  @override
  List<Object?> get props => [isMaterialSelected];
}

// Event untuk toggle checkbox
class ToggleCheckBox extends LogisticEvent {
  final int index;
  final bool isChecked;

  const ToggleCheckBox({required this.index, required this.isChecked});

  @override
  List<Object?> get props => [index, isChecked];
}

// Event untuk submit form
class SubmitForm extends LogisticEvent {
  final int index;

  const SubmitForm(this.index);

  @override
  List<Object?> get props => [index];
}


// Event untuk fetch data logistics
class FetchLogistics extends LogisticEvent {
  @override
  List<Object> get props => [];
}


class SetVolumeReceived extends LogisticEvent {
  final int index;
  final String volume;

  SetVolumeReceived({required this.index, required this.volume});
  
  @override
 List<Object?> get props => [volume];
}

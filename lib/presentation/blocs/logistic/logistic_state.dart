import 'package:myapp/presentation/widgets/logistic/logistic_item.dart';
import 'package:equatable/equatable.dart';

class LogisticState {
  final List<LogisticItem> materialItems;
  final List<LogisticItem> equipmentItems;
  final List<bool> isChecked;
  final bool isMaterialSelected;
  final List<String?> volumeReceived; // New field to store received volumes

  LogisticState({
    required this.materialItems,
    required this.equipmentItems,
    required this.isChecked,
    required this.isMaterialSelected,
    required this.volumeReceived,
  });

  LogisticState copyWith({
    List<LogisticItem>? materialItems,
    List<LogisticItem>? equipmentItems,
    List<bool>? isChecked,
    bool? isMaterialSelected,
    List<String?>? volumeReceived,
  }) {
    return LogisticState(
      materialItems: materialItems ?? this.materialItems,
      equipmentItems: equipmentItems ?? this.equipmentItems,
      isChecked: isChecked ?? this.isChecked,
      isMaterialSelected: isMaterialSelected ?? this.isMaterialSelected,
      volumeReceived: volumeReceived ?? this.volumeReceived,
    );
  }


  @override
  List<Object> get props => [materialItems, equipmentItems, isChecked, isMaterialSelected];
}

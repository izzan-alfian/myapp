import 'package:myapp/presentation/widgets/logistic/logistic_item.dart';
import 'package:equatable/equatable.dart';

class LogisticState extends Equatable {
  final List<LogisticItem> materialItems;
  final List<LogisticItem> equipmentItems;
  final List<bool> isChecked;
  final bool isMaterialSelected;

  LogisticState({
    required this.materialItems,
    required this.equipmentItems,
    required this.isChecked,
    required this.isMaterialSelected,
  });

  LogisticState copyWith({
    List<LogisticItem>? materialItems,
    List<LogisticItem>? equipmentItems,
    List<bool>? isChecked,
    bool? isMaterialSelected,
  }) {
    return LogisticState(
      materialItems: materialItems ?? this.materialItems,
      equipmentItems: equipmentItems ?? this.equipmentItems,
      isChecked: isChecked ?? this.isChecked,
      isMaterialSelected: isMaterialSelected ?? this.isMaterialSelected,
    );
  }

  @override
  List<Object> get props => [materialItems, equipmentItems, isChecked, isMaterialSelected];
}

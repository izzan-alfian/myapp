import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_event.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_state.dart';
import 'package:myapp/presentation/widgets/logistic/logistic_item.dart';

class LogisticBloc extends Bloc<LogisticEvent, LogisticState> {
  LogisticBloc()
      : super(LogisticState(
          materialItems: _initialMaterialItems(),
          equipmentItems: _initialEquipmentItems(),
          isChecked: List.generate(_initialMaterialItems().length, (index) => false), // Initial checkbox for materials
          isMaterialSelected: true,
        )) {
    // Registering event handlers
    on<FetchLogistics>(_onFetchLogistics);
    on<ToggleLogisticType>(_onToggleLogisticType);
    on<ToggleCheckBox>(_onToggleCheckBox);
  }

  void _onFetchLogistics(FetchLogistics event, Emitter<LogisticState> emit) {
    emit(state.copyWith(
      materialItems: _initialMaterialItems(),
      equipmentItems: _initialEquipmentItems(),
      isChecked: List.generate(_initialMaterialItems().length, (index) => false),
    ));
  }

  void _onToggleLogisticType(ToggleLogisticType event, Emitter<LogisticState> emit) {
    List<bool> newCheckedList;
    if (event.isMaterialSelected) {
      newCheckedList = List.generate(state.materialItems.length, (index) => false);
    } else {
      newCheckedList = List.generate(state.equipmentItems.length, (index) => false);
    }
    emit(state.copyWith(isMaterialSelected: event.isMaterialSelected, isChecked: newCheckedList));
  }

  void _onToggleCheckBox(ToggleCheckBox event, Emitter<LogisticState> emit) {
    List<bool> updatedChecked = List.from(state.isChecked);
    updatedChecked[event.index] = event.isChecked;
    emit(state.copyWith(isChecked: updatedChecked));
  }

  // Initial data for material items
  static List<LogisticItem> _initialMaterialItems() {
    return [
      LogisticItem(name: 'Batu Belah', quantity: '60 m3'),
      LogisticItem(name: 'Semen 3 Roda', quantity: '30 sak'),
      LogisticItem(name: 'Pasir', quantity: '300 m3'),
      LogisticItem(name: 'Keramik', quantity: '25 pack'),
      LogisticItem(name: 'Besi Beton', quantity: '100 batang'),
      LogisticItem(name: 'Batu Split', quantity: '150 m3'),
      LogisticItem(name: 'Kayu Balok', quantity: '50 batang'),
      LogisticItem(name: 'Paku 7 cm', quantity: '10 kg'),
      LogisticItem(name: 'Cat Tembok', quantity: '40 kaleng'),
      LogisticItem(name: 'Plafon Gypsum', quantity: '80 lembar'),
      LogisticItem(name: 'Pipa PVC 3 inch', quantity: '25 batang'),
      LogisticItem(name: 'Bata Merah', quantity: '5000 buah'),
      LogisticItem(name: 'GRC Board', quantity: '100 lembar'),
      LogisticItem(name: 'Triplek 9 mm', quantity: '50 lembar'),

    ];
  }

  // Initial data for equipment items
  static List<LogisticItem> _initialEquipmentItems() {
    return [
      LogisticItem(name: 'Mobil Pickup', quantity: '2'),
      LogisticItem(name: 'Mobil Molen', quantity: '1'),
      LogisticItem(name: 'Gerobak', quantity: '5'),
      LogisticItem(name: 'Pengki', quantity: '12'),
      LogisticItem(name: 'Bor Listrik', quantity: '6'),
      LogisticItem(name: 'Cangkul', quantity: '7'),
      LogisticItem(name: 'Cone Pembatas', quantity: '24'),
    ];
  }
}

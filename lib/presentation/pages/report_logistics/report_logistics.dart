import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_bloc.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_event.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_state.dart';
import 'package:myapp/presentation/widgets/logistic/logistic_item.dart';
import 'package:myapp/presentation/widgets/logistic/material_form.dart'; // Import halaman material form

class ReportLogistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inisialisasi fetch logistics saat widget dibangun
    BlocProvider.of<LogisticBloc>(context).add(FetchLogistics());

    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF33499e),
        title: const Text('Logistics Report', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Tambahkan logika pencarian di sini
            },
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Tambahkan logika filter di sini
            },
          ),
        ],
      ),
      body: BlocBuilder<LogisticBloc, LogisticState>(
        builder: (context, state) {
          // Jika belum ada data, tampilkan loading indicator
          if (state.materialItems.isEmpty && state.equipmentItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          List<LogisticItem> items = state.isMaterialSelected
              ? state.materialItems
              : state.equipmentItems;

          return Column(
            children: [
              // Filter Toggle Buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ToggleButtons(
                  color: Colors.white,
                  selectedColor: Colors.white,
                  fillColor: const Color(0xFF33499e),
                  borderColor: Colors.white,
                  selectedBorderColor: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  isSelected: [
                    state.isMaterialSelected,
                    !state.isMaterialSelected,
                  ],
                  onPressed: (index) {
                    BlocProvider.of<LogisticBloc>(context).add(
                      ToggleLogisticType(index == 0), // Event ToggleLogisticType
                    );
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.pallet, color: state.isMaterialSelected ? Colors.white : Colors.grey),
                          const SizedBox(width: 4),
                          Text('Material', style: TextStyle(color: state.isMaterialSelected ? Colors.white : Colors.grey)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.build, color: !state.isMaterialSelected ? Colors.white : Colors.grey),
                          const SizedBox(width: 4),
                          Text('Equipment', style: TextStyle(color: !state.isMaterialSelected ? Colors.white : Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ListView with items
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index].name),
                      subtitle: Text('Quantity: ${items[index].quantity}'),
                      trailing: Checkbox(
                        value: state.isChecked[index],
                        onChanged: (bool? value) {
                          BlocProvider.of<LogisticBloc>(context).add(
                            ToggleCheckBox(index: index, isChecked: value ?? false), // Event ToggleCheckBox
                          );
                        },
                      ),
                      onTap: () {
                        // Navigasi ke MaterialFormPage saat item ListView ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaterialFormPage(index: index), // Mengirim index item ke MaterialFormPage
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

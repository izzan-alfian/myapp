import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_bloc.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_event.dart';

class MaterialFormPage extends StatefulWidget {
  final int index;

  MaterialFormPage({required this.index});

  @override
  _MaterialFormPageState createState() => _MaterialFormPageState();
}

class _MaterialFormPageState extends State<MaterialFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool isChecked = false;
  String volumeOrdered = '60 m3'; // Default value for Volume Ordered
  String? volumeReceived; // Volume Received value, initially null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33499e),
        title: const Text('Material Form', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Type',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                readOnly: true,
                initialValue: 'Batu Belah', // Default value
              ),
              SizedBox(height: 20),

              // Volume Ordered
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Volume Ordered',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                readOnly: true,
                initialValue: volumeOrdered,
              ),
              SizedBox(height: 20),

              // Volume Received
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Volume Received',
                ),
                initialValue: volumeReceived,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter volume received';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    volumeReceived = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Checkbox for "according to order"
              Row(
                children: [
                 Checkbox(
                  value: isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      isChecked = newValue ?? false;
                      if (isChecked) {
                        // Set volumeReceived equal to volumeOrdered using Bloc
                        context.read<LogisticBloc>().add(ToggleCheckBox(index: widget.index, isChecked: true));
                      } else {
                        context.read<LogisticBloc>().add(ToggleCheckBox(index: widget.index, isChecked: false));
                      }
                    });
                  },
                ),
                  Text('according to order'),
                ],
              ),
              SizedBox(height: 20),

              // Description field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<LogisticBloc>()
                          .add(ToggleCheckBox(index: widget.index, isChecked: isChecked));
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

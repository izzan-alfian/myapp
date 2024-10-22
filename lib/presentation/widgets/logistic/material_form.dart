import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_bloc.dart';
import 'package:myapp/presentation/blocs/logistic/logistic_event.dart';

class MaterialFormPage extends StatelessWidget {
  final int index;

  MaterialFormPage({required this.index});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Material Form'),
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
                ),
                initialValue: '60 m3',
                readOnly: true, // Fixed value as per the image
              ),
              SizedBox(height: 20),

              // Volume Received
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Volume Received',
                ),
                initialValue: '56 m3', // Default value
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter volume received';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Checkbox for "according to order"
              Row(
                children: [
                  Checkbox(
                    value: false, // Default state
                    onChanged: (newValue) {
                      context.read<LogisticBloc>().add(ToggleCheckBox(index: index, isChecked: newValue ?? false));
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
                      context.read<LogisticBloc>().add(ToggleCheckBox(index: index, isChecked: true));
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

import 'package:flutter/material.dart';

class AttendancesLeaves extends StatefulWidget {
  @override
  _AttendancesLeavesState createState() => _AttendancesLeavesState();
}

class _AttendancesLeavesState extends State<AttendancesLeaves> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isHalfDay = false;
  String? _selectedLeaveType;
  String? _selectedHalfDayType;
  List<String> leaveTypes = ['Unpaid Leaves', 'Paid Leaves', 'Sick Leave'];
  List<String> halfDayOptions = ['Morning', 'Afternoon'];
  DateTime? _fromDate;
  DateTime? _toDate;
  String _durationText = '';
  bool _isError = false; // Flag to check if there's an error
  bool _isFormValid = false; // Flag for form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF33499e),
        title: Text('Leaves Form', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            TextField(
              controller: _nameController,
              // onChanged: _validateForm,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16),

            // From Date
            TextField(
              controller: _fromDateController,
              onChanged: (value) => _validateForm(),
              decoration: InputDecoration(
                labelText: 'From Date',
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await _selectDate(context);
                if (pickedDate != null) {
                  setState(() {
                    _fromDate = pickedDate;
                    _fromDateController.text =
                        pickedDate.toString().split(' ')[0];
                    _updateDuration();
                  });
                  _validateForm();
                }
              },
            ),
            SizedBox(height: 16),

            // To Date with Half Day checkbox
            Row(
              children: [
                Expanded(
                  child: _isHalfDay
                      ? DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Half Day',
                            border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          value: _selectedHalfDayType,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedHalfDayType = newValue;
                              _updateDuration();
                            });
                            _validateForm();
                          },
                          items: halfDayOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      : TextField(
                          decoration: InputDecoration(
                            labelText: 'To Date',
                            border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await _selectDate(context);
                            if (pickedDate != null) {
                              setState(() {
                                _toDate = pickedDate;
                                _updateDuration();
                              });
                              _validateForm();
                            }
                          },
                          controller: TextEditingController(
                            text: _toDate != null
                                ? _toDate.toString().split(' ')[0]
                                : '',
                          ),
                        ),
                ),
                SizedBox(width: 10),
                Checkbox(
                  value: _isHalfDay,
                  onChanged: (bool? value) {
                    setState(() {
                      _isHalfDay = value!;
                      _updateDuration(); // Update duration if half day changes
                    });
                    _validateForm();
                  },
                ),
                Text('Half Day'),
              ],
            ),
            SizedBox(height: 16),

            // Duration Text or Error
            Text(
              _isError
                  ? 'Error: Invalid date range (negative duration)'
                  : 'Duration: $_durationText',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    _isError ? Colors.red : Colors.black, // Error text in red
              ),
            ),
            SizedBox(height: 16),

            // Leaves Type
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Leaves Type',
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              value: _selectedLeaveType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLeaveType = newValue;
                });
                _validateForm();
              },
              items: leaveTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              onChanged: (value) => _validateForm(),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid ? _handleSubmit : null, // Hanya bisa ditekan jika form valid
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? Color(0xFF33499e) : Colors.grey, // Ubah warna sesuai kondisi
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to select date
  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  void _updateDuration() {
    if (_fromDate != null && _toDate != null) {
      int durationInDays = _toDate!.difference(_fromDate!).inDays + 1;

      if (_isHalfDay) {
        // Set half-day values to the new decimals
        double halfDayValue = _selectedHalfDayType == 'Morning' ? 0.44 : 0.56;

        if (durationInDays < 1) {
          // Error if date range is invalid
          _isError = true;
        } else {
          _durationText =
              '${halfDayValue.toStringAsFixed(2)} day (${_selectedHalfDayType ?? ''})';
          _isError = false;
        }
      } else {
        if (durationInDays < 0) {
          // Error if date range is invalid (negative duration)
          _isError = true;
        } else {
          _durationText = '$durationInDays days';
          _isError = false;
        }
      }
    } else {
      _durationText = '';
      _isError = false;
    }
  }

  // Validate form to enable or disable the submit button
  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.isNotEmpty &&
          _fromDateController.text.isNotEmpty &&
          (_toDate != null || _isHalfDay) &&
          _selectedLeaveType != null &&
          _descriptionController.text.isNotEmpty;
    });
  }

  // Handle form submission
  void _handleSubmit() {
    // Show a confirmation pop-up
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Your leave request has been submitted.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

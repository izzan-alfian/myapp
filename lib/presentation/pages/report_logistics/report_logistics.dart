import 'package:flutter/material.dart';

class ReportLogistics extends StatefulWidget {
  @override
  _ReportLogisticsState createState() => _ReportLogisticsState();
}

class _ReportLogisticsState extends State<ReportLogistics> {
  int _selectedIndex = 0; // 0 for Material, 1 for Equipment

  void _onToggleSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf0f0f0),
      appBar: AppBar(
        backgroundColor: Color(0xFF33499e),
        title: Text('Logistics Report', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Filter Toggle Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ToggleButtons(
              color: Colors.white,
              selectedColor: Colors.white,
              fillColor: Color(0xFF33499e),
              borderColor: Colors.white,
              selectedBorderColor: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              isSelected: [
                _selectedIndex == 0,
                _selectedIndex == 1,
              ],
              onPressed: _onToggleSelected,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.macro_off_outlined, color: _selectedIndex == 0 ? Colors.white : Colors.grey),
                      SizedBox(width: 4),
                      Text('Material', style: TextStyle(color: _selectedIndex == 0 ? Colors.white : Colors.grey)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.build, color: _selectedIndex == 1 ? Colors.white : Colors.grey),
                      SizedBox(width: 4),
                      Text('Equipment', style: TextStyle(color: _selectedIndex == 1 ? Colors.white : Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Display content based on selected filter
          Expanded(
            child: Center(
              child: Text(
                _selectedIndex == 0 ? 'Selected: Material' : 'Selected: Equipment',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

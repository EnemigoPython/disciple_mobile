import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_selectedDate != null
                ? 'Selected Date: ${_selectedDate.toString()}'
                : 'No date selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showDatePicker(context),
              child: Text('Show Date Picker'),
            ),
          ],
        ),
      ),
    );
  }
}

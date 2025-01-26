import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onUpdateDate;

  const DatePicker({super.key, required this.onUpdateDate});

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime _selectedDate = DateTime.now();
  late String dateTimeString;

  @override
  void initState() {
    super.initState();
    setState(() {
      dateTimeString = dateTimeToUkDateFormat(_selectedDate);
    });
  }

  String dateTimeToUkDateFormat(DateTime dateTime) {
    DateFormat ukDateFormat = DateFormat('dd/MM/yyyy');
    return ukDateFormat.format(dateTime);
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2060),
    ).then((pickedDate) {
      if (pickedDate != null) {
        updateSelectedDate(pickedDate);
      }
    });
  }

  void updateSelectedDate(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      dateTimeString = dateTimeToUkDateFormat(_selectedDate);
    });
    widget.onUpdateDate(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => updateSelectedDate(
                _selectedDate.subtract(const Duration(days: 1))
              ), 
              icon: Icon(Icons.arrow_left_rounded)
            ),
            ElevatedButton(
              onPressed: () => _showDatePicker(context),
              child: Text(dateTimeString),
            ),
            IconButton(
              onPressed: () => updateSelectedDate(
                _selectedDate.add(const Duration(days: 1))
              ),
              icon: Icon(Icons.arrow_right_rounded)
            ),
          ],
        ),
      ),
    );
  }
}

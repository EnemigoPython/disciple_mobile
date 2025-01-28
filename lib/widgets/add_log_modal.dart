import 'package:flutter/material.dart';

class AddLogModal extends StatefulWidget {
  const AddLogModal({super.key});
  
  @override
  State<AddLogModal> createState() => _AddLogModalState();
}

class _AddLogModalState extends State<AddLogModal> {
  String _text = 'Hello, World!';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modal Title'),
      content: Text(_text),
      actions: [
        TextButton(
          child: Text('Update Text'),
          onPressed: () {
            setState(() {
              _text = 'New text!';
            });
          },
        ),
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

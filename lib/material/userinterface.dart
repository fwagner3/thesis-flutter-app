import 'package:flutter/material.dart';

class UserInterfacePage extends StatefulWidget {
  const UserInterfacePage({ super.key });

  @override
  State<UserInterfacePage> createState() => _UserInterfacePageState();
}

class _UserInterfacePageState extends State<UserInterfacePage> {

  bool toggle = false;

  DateTime date = DateTime.now();

  // Show the dialog modal for datetime picker
  void _showDateTimeDialog(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100)
    );

    if (selectedDate != null) {
      setState(() {
        date = selectedDate;
      });
    }
  }

  // Show alert dialog
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('This is an alert'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK')
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Button',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              ),
              Container(height: 8.0),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Button')
              ),
              Container(height: 24.0),
              const Text(
                'Text Input',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              ),
              Container(height: 8.0),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Placeholder'
                ),
              ),
              Container(height: 24.0),
              const Text(
                'Mobile Push- / Pop-Navigation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              ),
              Container(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInterfaceSecondPage())
                  );
                },
                child: const Text('Navigate'),
              ),
              Container(height: 24.0),
              const Text(
                'Date- / Time-Picker',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              ),
              Container(height: 8.0),
              TextButton(
                onPressed: () {
                  _showDateTimeDialog(context);
                },
                child: Text('${date.month}-${date.day}-${date.year}')
              ),
              Container(height: 24.0),
              const Text(
                'Alert',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              ),
              Container(height: 8.0),
              ElevatedButton(
                onPressed: () => _showAlertDialog(context),
                child: const Text('Trigger Alert')
              ),
              Container(height: 24.0),
              const Text(
                'Toggle',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              ),
              Container(height: 8.0),
              Switch(
                value: toggle,
                onChanged: (bool value) {
                  setState(() {
                    toggle = value;
                  });
                }
              )
            ]
          ),
        )
      )
    );
  }
}

class UserInterfaceSecondPage extends StatelessWidget {
  UserInterfaceSecondPage({ super.key });

  List<Widget> items = [
    const Text('Page Two')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Two')
      ),
      body: Container()
    );
  }
}
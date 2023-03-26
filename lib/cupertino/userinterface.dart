import 'package:flutter/cupertino.dart';

class UserInterfacePage extends StatefulWidget {
  const UserInterfacePage({ super.key });

  @override
  State<UserInterfacePage> createState() => _UserInterfacePageState();
}

class _UserInterfacePageState extends State<UserInterfacePage> {
  DateTime dateTime = DateTime(2023, 2, 2, 23, 36);

  bool toggle = false;
  
  // Show the dialog modal for datetime picker
  void _showDialog(Widget child) {
    showCupertinoModalPopup(
      context: context, 
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child
        )
      )
    );
  }

  // Show alert dialog
  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('This is an alert'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
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
            CupertinoButton(
              child: const Text(
                'Button'
              ),
              onPressed: () {},
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
            const CupertinoTextField(
              placeholder: 'Placeholder',
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
            CupertinoButton(
              child: const Text('Navigate'),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        UserInterfaceSecondPage()));
              },
            ),
            Container(height: 24.0),
            const Text(
              'Date- / Time-Picker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              )
            ),
            CupertinoButton(
              onPressed: () => _showDialog(
                CupertinoDatePicker(
                  initialDateTime: dateTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      dateTime = newDateTime;
                    });
                  },
                )
              ),
              child: Text(
                '${dateTime.month}-${dateTime.day}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}'
              )
            ),
            Container(height: 8.0),
            const Text(
              'Alert',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              )
            ),
            Container(height: 8.0),
            CupertinoButton(
              child: const Text('Trigger Alert'),
              onPressed: () => _showAlertDialog(context),
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
            CupertinoSwitch(
              value: toggle,
              activeColor: CupertinoColors.activeBlue,
              onChanged: (bool? value) {
                setState(() {
                  toggle = value ?? false;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class UserInterfaceSecondPage extends StatelessWidget {
  UserInterfaceSecondPage({super.key});

  List<Widget> items = [
    const Text('Page Two')
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Page Two'),
            leading: CupertinoNavigationBarBackButton()),
        child: Container()
    );
  }
}

import 'package:flutter/material.dart';
import './material/nativefeatures.dart';
import './material/performance.dart';
import './material/userinterface.dart';

class materialWidget extends StatefulWidget {
  const materialWidget({ super.key });

  @override
  State<materialWidget> createState() => _materialWidgetState();
}

class _materialWidgetState extends State<materialWidget> {
  int _selectedIndex = 0;
  
  static const List<Widget> _widgetOptions = <Widget>[
    PerformancePage(),
    UserInterfacePage(),
    NativeFeaturesPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Performance'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.palette),
              label: 'User Interface'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Native Features'
            )
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
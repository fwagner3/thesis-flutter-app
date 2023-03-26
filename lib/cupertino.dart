import 'package:flutter/cupertino.dart';
import './cupertino/nativefeatures.dart';
import './cupertino/userinterface.dart';
import './cupertino/performance.dart';

Widget cupertinoWidget(BuildContext context) {
  return CupertinoApp(
    home: CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.speedometer),
            label: 'Performance'
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.paintbrush),
            label: 'User Interface'
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3),
            label: 'Native Features'
          )
        ]
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            if (index == 2) {
              return const NativeFeaturesPage();
            } else if (index == 1) {
              return const UserInterfacePage();
            } else if (index == 0) {
              return const PerformancePage();
            }

            return Center(
              child: Text('Content of tab $index')
            );
          }
        );
      },
    ),
    debugShowCheckedModeBanner: false,
  );
}
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import './cupertino.dart';
import './material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isAndroid) {
      return const materialWidget();
    } else if (UniversalPlatform.isIOS) {
      return cupertinoWidget(context);
    }

    return Container();
  }
}
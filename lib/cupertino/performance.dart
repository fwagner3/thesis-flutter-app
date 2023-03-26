import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:flutter/scheduler.dart';

// 3D-Rotation from https://stackoverflow.com/questions/50457809/rotate-3d-on-x-in-flutter

class PerformancePage extends StatefulWidget {
  const PerformancePage({ super.key });

  @override
  State<PerformancePage> createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> with TickerProviderStateMixin {

  static Matrix4 mat(num pv) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, pv * 0.001,
      0.0, 0.0, 0.0, 1.0
    );
  }

  Matrix4 perspective = mat(1.0);

  var rotationAngle = 0.0;
  var opacityValue = 0.0;

  AnimationController? _controller;
  AnimationController? _opacityController;

  var imgs = List.generate(30, (index) => index.toString());

  int _frameCounter = 0;

  // Add to the frame counter, everytime this function is called
  void _frameTick(Duration d) {
    _frameCounter += 1;
  }

  // Measure the FPS by increasing a counter every rendered frame for a fixed period of time
  Future<double> measureFPS() async {
    _frameCounter = 0;

    var ticker = Ticker(_frameTick);
    ticker.start();

    await Future.delayed(const Duration(seconds: 10), () => {
      ticker.stop()
    });

    return (_frameCounter / 10);
  }

  List<double> framerates = [];

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 359.0,
      duration: const Duration(seconds: 2)
    )
      ..forward()
      ..addListener(() {
        if (_controller!.isCompleted) {
          _controller!.repeat();
        }
      })
    ;
    _controller!.addListener(() {
      setState(() {
        rotationAngle = _controller!.value;
      });
    });
    _opacityController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(seconds: 2)
    )
      ..forward()
      ..addListener(() {
        if (_opacityController!.isCompleted) {
          _opacityController!.repeat();
        }
      });
    _opacityController!.addListener(() {
      setState(() {
        opacityValue = _opacityController!.value;
      });
    });

    // Run the FPS test five times and show the results
    void runFPSTests() async {
      List<double> results = [];

      for (int i = 0; i < 5; i++) {
        double res = await measureFPS();
        results.add(res);
      }

      setState(() {
        framerates = results;
      });
    }

    runFPSTests();

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    _opacityController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Framerate: ${framerates.join(",")}'),
          ),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/test.jpeg')
              )
            ),
            child: Wrap(
              children: [
                ...imgs.map((img) => Transform(
                  alignment: FractionalOffset.center,
                  transform: perspective.scaled(1.0, 1.0, 1.0)
                    ..rotateX(pi - rotationAngle * pi / 180)
                    ..rotateY(pi - rotationAngle * pi / 180)
                    ..rotateZ(pi - rotationAngle * pi / 180),
                  child: Opacity(
                    opacity: opacityValue,
                    child: Image.asset(
                      'assets/test.jpeg',
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 5
                    ),
                  )
                )
                ),
              ],
            )
          )
        ]
      )
    );
  }
}
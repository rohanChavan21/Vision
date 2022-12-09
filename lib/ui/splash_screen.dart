import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vision_app/ui/tab_view.dart';
import 'package:vision_app/ui/voice_screen.dart';
import 'package:volume_controller/volume_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController? animationController;
  Animation<double>? animation;

  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TabViewScreen()));
  }

  @override
  initState() {
    super.initState();
    VolumeController().getVolume().then(
      (currentVol) {
        if (currentVol < 0.5) {
          VolumeController().setVolume(0.5);
        }
      },
    );

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => setState(() {}));
    animationController!.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: const Color.fromARGB(255, 247, 191, 80),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/app_logo.png',
              width: animation!.value * 250,
              //height: animation!.value * 250,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:starlibrary/pages/welcome.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 1),
      () {
        setState(() {
          opacityLevel = 1.0;
        });
      },
    );
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Welcome()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: opacityLevel,
          child: Image.asset('assets/logo.png', width: 200, height: 200),
        ),
      ),
    );
  }
}

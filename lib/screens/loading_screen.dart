//giving the user intuition of loading for 4 seconds

import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int x = 0;
  void func() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false );
  }

  @override
  void initState() {
    super.initState();
    func();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading..',
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900]),
            ),
            SizedBox(height: 30),
            SpinKitCubeGrid(
              color: Colors.blueGrey[900],
              size: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}

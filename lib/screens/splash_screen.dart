import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff040316),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 50,
              ),
            ),
            Container(
              height: 60,
              child: SpinKitSquareCircle(
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CounterIcon extends StatelessWidget {
  final IconData iconData;
  final int count;
  CounterIcon({required this.iconData, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Icon(iconData),
        count == 0
            ? SizedBox()
            : Positioned(
                // draw a red marble
                top: -5.0,
                right: -5.0,
                child: Stack(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: Text(
                        '$count',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

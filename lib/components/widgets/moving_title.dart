import 'package:marquee/marquee.dart';
import 'package:flutter/material.dart';

class MovingTitle extends StatelessWidget {
  final String text;
  const MovingTitle(this.text) : super();

  @override
  Widget build(BuildContext context) {
    return Marquee(
      text: text,
      style: TextStyle(fontFamily: 'Tiny', fontSize: 45, color: Colors.black),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 20.0,
      velocity: 80.0,
      pauseAfterRound: Duration(seconds: 8),
      startPadding: 10.0,
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class Home extends StatefulWidget {
  const Home() : super();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Color> colors = [Colors.black, Colors.red, Colors.blue, Colors.green];

  @override
  Widget build(BuildContext context) {
    return TikTokStyleFullPageScroller(
      contentSize: colors.length,
      swipePositionThreshold: 0.2,
      swipeVelocityThreshold: 2000,
      animationDuration: const Duration(milliseconds: 200),
      builder: (BuildContext context, int index) {
        return Container(
          color: colors[index],
          child: Text(
            '$index',
            style: const TextStyle(fontSize: 48, color: Colors.white),
          ),
        );
      },
    );
  }
}

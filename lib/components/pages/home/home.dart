import 'package:eventy_front/components/pages/home/recomendation.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class Home extends StatefulWidget {
  const Home() : super();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Color> colors = [Colors.black, Colors.red, Colors.blue, Colors.green];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    EventService().get().then((value) => setState(() {
          print("Here");
          events = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return events.length > 0
        ? TikTokStyleFullPageScroller(
            contentSize: events.length,
            swipePositionThreshold: 0.1,
            swipeVelocityThreshold: 500,
            animationDuration: const Duration(milliseconds: 200),
            builder: (BuildContext context, int index) {
              return RecommendedEvent(events[index]);
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

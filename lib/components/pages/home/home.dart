import 'package:eventy_front/components/pages/home/recomendation.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class Home extends StatefulWidget {
  final _HomeState homeState = _HomeState();

  @override
  _HomeState createState() {
    return homeState;
  }
}

class _HomeState extends State<Home> {
  List<Color> colors = [Colors.black, Colors.red, Colors.blue, Colors.green];
  List<Event> events = [];
  late Event currentEvent;

  @override
  void initState() {
    super.initState();
    EventService().get().then((value) => setState(() {
          print("Here");
          events = value;
          currentEvent = events.first;
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
            onScrollEvent: _handleCallbackEvent,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null) {
      setState(() {
        currentEvent = events[currentIndex];
      });
    }
  }

  addMemberToEvent() {
    EventService().sendNewParticipant(
        currentEvent.id.toString(), "G1edlrx1jnguSaFfTJctxJoFNPA2");
  }

  buildMessageAddEvent() {
    addMemberToEvent();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Te has unido con éxito",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black87),
            ),
            content: Text("Evento añadido a: Mis eventos."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Vale",
                    style: TextStyle(color: Colors.lightBlue),
                  ))
            ],
          );
        });
  }
}

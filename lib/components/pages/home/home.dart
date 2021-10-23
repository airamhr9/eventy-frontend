import 'package:eventy_front/components/pages/home/recomendation.dart';
import 'package:eventy_front/components/pages/login/login.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
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

  addMemberToEvent() async {
    EventService().sendNewParticipant(currentEvent.id.toString(),
        await MySharedPreferences.instance.getStringValue("userId"));
  }

  buildMessageAddEvent() async {
    String userId = await MySharedPreferences.instance.getStringValue("userId");
    bool userIsParticpant = false;
    for (String userIdInList in currentEvent.participants) {
      if (userId == userIdInList) {
        userIsParticpant = true;
      }
    }
    if (userIsParticpant == true) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Ya estas en este evento",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black87),
              ),
              content: Text(
                  "Puedes encontrar el evento en la pantalla: Mis eventos."),
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
    } else {
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
}

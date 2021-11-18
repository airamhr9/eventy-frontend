import 'package:eventy_front/components/pages/my_events/event_card.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/objects/user_group.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:eventy_front/services/group_service.dart';
import 'package:flutter/material.dart';

class GroupRecomendedEvents extends StatefulWidget {
  final Group group;
  final bool groupLider;
  const GroupRecomendedEvents(this.group, this.groupLider) : super();

  @override
  _GroupRecomendedEventsState createState() => _GroupRecomendedEventsState();
}

class _GroupRecomendedEventsState extends State<GroupRecomendedEvents> {
  late List<Event> events;
  late String userId;
  late bool todosFiltrosOk;

  @override
  void initState() {
    super.initState();
    /*GroupService().get().then((value) => setState(() {
          if (todosFiltrosOk) {
            print("Añadiendo eventos recomendados para el grupo");
            events = value;
          } else {

          }
        }));*/
  }

  @override
  Widget build(BuildContext context) {
    return events.length > 0
        ? Scaffold(
            appBar: AppBar(),
            body: (SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    ...events.map((event) => Column(children: [
                          EventCard(event),
                          buildButtonAddMembers(event.id),
                          Divider()
                        ]))
                  ],
                ),
              ),
            )),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  buildButtonAddMembers(int eventId) {
    if (widget.groupLider) {
      return ElevatedButton.icon(
          onPressed: () {
            for (UserGroup user in widget.group.users) {
              EventService()
                  .sendNewParticipant(eventId.toString(), user.id, "true");
            }
          },
          icon: Icon(Icons.add_rounded),
          label: Text("Añadir miembros del grupo al evento"));
    } else {}
  }
}

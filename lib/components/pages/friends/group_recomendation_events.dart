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
  final bool userIsGroupLider;
  const GroupRecomendedEvents(this.group, this.userIsGroupLider) : super();

  @override
  _GroupRecomendedEventsState createState() => _GroupRecomendedEventsState();
}

class _GroupRecomendedEventsState extends State<GroupRecomendedEvents> {
  List<Event> events = [];
  List<Event> eventsSinStartDate = [];
  List<Event> eventsSinFinishDate = [];
  List<Event> eventsSinPrice = [];
  late String userId;
  bool filtrosOk = false;
  bool oneList = false;
  bool threeLists = false;

  @override
  void initState() {
    super.initState();
    GroupService()
        .getRecomendedEvents(widget.group.id)
        .then((value) => setState(() {
              if (value != []) {
                print("Añadiendo eventos recomendados para el grupo");
                if (value.length == 2) {
                  events = value[1];
                  oneList = true;
                  filtrosOk = true;
                } else {
                  eventsSinStartDate = value[1];
                  eventsSinFinishDate = value[2];
                  eventsSinPrice = value[3];
                  threeLists = true;
                  filtrosOk = true;
                }
              } else {
                filtrosOk = false;
              }
            }));
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
                  child: buildRecomendedEventList() //////////////////////
                  ),
            )),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  buildRecomendedEventList() {
    if (filtrosOk == true) {
      if (events.isNotEmpty) {
        buildOneList();
      } else {
        buildEventListSinStartDate();
        buildEventListSinFinishDate();
        buildEventListSinPrice();
      }
    } else {
      return Center(
        child: Text("No se han encontrado eventos"),
      );
    }
  }

  Widget buildOneList() {
    return Column(
      children: [
        ...events.map((event) => Column(children: [
              EventCard(event),
              buildButtonAddMembers(event.id),
              Divider()
            ]))
      ],
    );
  }

  buildEventListSinStartDate() {
    if (eventsSinStartDate.isNotEmpty) {
      return Column(
        children: [
          Text("Eventos sin fecha de inicio"),
          ...eventsSinStartDate.map((event) => Column(children: [
                EventCard(event),
                buildButtonAddMembers(event.id),
                Divider()
              ]))
        ],
      );
    }
  }

  buildEventListSinFinishDate() {
    if (eventsSinFinishDate.isNotEmpty) {
      return Column(
        children: [
          Text("Eventos sin fecha de finalización"),
          ...eventsSinFinishDate.map((event) => Column(children: [
                EventCard(event),
                buildButtonAddMembers(event.id),
                Divider()
              ]))
        ],
      );
    }
  }

  buildEventListSinPrice() {
    if (eventsSinPrice.isNotEmpty) {
      return Column(
        children: [
          Text("Eventos sin precio"),
          ...eventsSinPrice.map((event) => Column(children: [
                EventCard(event),
                buildButtonAddMembers(event.id),
                Divider()
              ]))
        ],
      );
    }
  }

  buildButtonAddMembers(int eventId) {
    if (widget.userIsGroupLider == true) {
      return ElevatedButton.icon(
          onPressed: () {
            GroupService()
                .sendGroupUsersToEvent(widget.group.id, eventId.toString());
          },
          icon: Icon(Icons.add_rounded),
          label: Text("Añadir miembros del grupo al evento"));
    }
  }
}

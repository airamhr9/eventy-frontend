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
  bool wait = true;
  bool filtrosOk = false;

  @override
  void initState() {
    super.initState();
    GroupService()
        .getRecomendedEvents(widget.group.id)
        .then((value) => setState(() {
              print(value);
              print("Añadiendo eventos recomendados para el grupo");
              if (value.length > 1) {
                eventsSinStartDate = value[0];
                eventsSinFinishDate = value[1];
                eventsSinPrice = value[2];
                filtrosOk = false;
                wait = false;
              } else {
                events = value[0];
                print(events);
                filtrosOk = true;
                wait = false;
              }
              print("ya tengo los eventos");
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos recomendados"),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 1)),
          color: Colors.white,
        ),
        child: (SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: buildRecomendedEventList()),
        )),
      ),
    );
  }

  Widget buildRecomendedEventList() {
    if (wait == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (filtrosOk == true) {
        return buildOneList();
      } else {
        return buildThreeListOrMessageNoEvents();
      }
    }
  }

  buildOneList() {
    return Column(
      children: [
        ...events.map((event) => Column(children: [
              Divider(
                height: 0,
                color: Colors.black,
                thickness: 1,
              ),
              EventCard(event),
              Divider(
                height: 0,
                color: Colors.black,
                thickness: 1,
              ),
              buildButtonAddMembers(event.id),
            ]))
      ],
    );
  }

  buildThreeListOrMessageNoEvents() {
    if (eventsSinFinishDate.isNotEmpty ||
        eventsSinPrice.isNotEmpty ||
        eventsSinStartDate.isNotEmpty) {
      if (eventsSinStartDate.isNotEmpty) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Eventos sin filtro de fecha de inicio",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ...eventsSinStartDate.map((event) => Column(children: [
                  Divider(
                    height: 0,
                    color: Colors.black,
                    thickness: 1,
                  ),
                  EventCard(event),
                  Divider(
                    height: 0,
                    color: Colors.black,
                    thickness: 1,
                  ),
                  buildButtonAddMembers(event.id),
                ]))
          ],
        );
      }
      if (eventsSinFinishDate.isNotEmpty) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Eventos sin filtro de fecha de finalización",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ...eventsSinFinishDate.map((event) => Column(children: [
                  Divider(
                    height: 0,
                    color: Colors.black,
                    thickness: 1,
                  ),
                  EventCard(event),
                  Divider(
                    height: 0,
                    color: Colors.black,
                    thickness: 1,
                  ),
                  buildButtonAddMembers(event.id),
                ]))
          ],
        );
      }
      if (eventsSinPrice.isNotEmpty) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Eventos sin filtro de precio",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ...eventsSinPrice.map((event) => Column(children: [
                  Divider(
                    height: 0,
                    color: Colors.black,
                    thickness: 1,
                  ),
                  EventCard(event),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  buildButtonAddMembers(event.id),
                ]))
          ],
        );
      }
    } else {
      return buildTextNoEvents();
    }
  }

  buildTextNoEvents() {
    return Center(
      child: Text(
        "No se han encontrado eventos con esos filtros",
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
      ),
    );
  }

  buildButtonAddMembers(int eventId) {
    if (widget.userIsGroupLider == true) {
      return ElevatedButton(
          onPressed: () {
            bool allMembersOk = true;
            for (UserGroup user in widget.group.users) {
              if (user.validPreferences != true) {
                allMembersOk = false;
              }
            }
            if (allMembersOk) {
              GroupService()
                  .addGroupUsersToEvent(widget.group.id, eventId.toString());
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "¡Miembros añadidos con exito!",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Vale",
                            )),
                      ],
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Hay miembros que no han confirmado su aistencia",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Vale",
                            )),
                      ],
                    );
                  });
            }
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text("Inscribir miembros del grupo"));
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }
}

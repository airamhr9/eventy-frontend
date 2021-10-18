import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';

class Participants extends StatefulWidget {
  final Event event;
  const Participants(this.event) : super();

  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  List<User> participantsList = [];

  @override
  void initState() {
    super.initState();
    EventService().getParticipants(widget.event.id.toInt())
        .then((value) => setState(() {
              print("Here");
              participantsList = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Asistentes"),
          automaticallyImplyLeading: true,
        ),
        body: (Container(
            color: Color(0xFFFAFAFA),
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.event.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.event.startDate,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.event.participants.length.toString() +
                      "/" +
                      widget.event.maxParticipants.toString() +
                      " asistentes",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...participantsList.map((participant) => ListTile(
                                  leading: CircleAvatar(
                                    foregroundImage: AssetImage(participant.profilePicture),
                                  ),
                                  title: Text(participant.name),
                                ))
                      ],
                    ),
                  ),
                )
              ],
            ))));
  }
}

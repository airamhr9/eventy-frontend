import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Participants extends StatefulWidget {
  final Event event;
  const Participants(this.event) : super();

  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  List<List<User>> participantsList = [];
bool loading = true;

  @override
  void initState() {
    super.initState();
    EventService()
        .getParticipants(widget.event.id.toString())
        .then((value) => setState(() {
      print("Here");
      participantsList = value;
      loading = false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.blue[500],
        body: Column(
          children: [
            Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                width: double.infinity,
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
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat("dd/MM/yyyy HH:mm")
                            .format(DateTime.parse(widget.event.startDate)),
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      buildText(widget.event.maxParticipants),
                      SizedBox(
                        height: 20,
                      ),
                    ])),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Usuarios que asistirán",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20, color: Colors.blueAccent),

                      ),

                      (!loading)?
                      (participantsList[0].length > 0 )?
                      Column(children: [
                        ...participantsList[0].map((participant) => ListTile(
                          leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      participant.profilePicture,

                                    )),
                              )),
                          title: Text(participant.userName),
                        ))
                      ],):SizedBox():Center(child: CircularProgressIndicator()),
                      SizedBox(height: 15),
                      Text("Usuarios en duda",
    style: TextStyle(
    fontWeight: FontWeight.w500, fontSize: 20, color: Colors.orangeAccent),

                      ),

                      (!loading)?
                      (participantsList[1].length > 0 )?
                      Column(

                        children: [
                        ...participantsList[1].map((participant) => ListTile(
                          leading: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      participant.profilePicture,

                                    )),
                              )),
                          title: Text(participant.userName),
                        ))
                      ],):SizedBox():Center(child: SizedBox())
                    ],

                   ),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildText(int maxParticipants) {
    print(maxParticipants);
    int numberParticipants = widget.event.participants.length;
    if (maxParticipants == -1) {
      String asistentes =
      (numberParticipants == 1) ? " asistente." : " asistentes.";
      return Text(
        numberParticipants.toString() + asistentes,
        style: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
      );
    } else {
      String plazasOcupadas =
      (numberParticipants == 1) ? " plaza ocupada." : " plazas ocupadas.";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            numberParticipants.toString() +
                "/" +
                widget.event.maxParticipants.toString() +
                plazasOcupadas,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                color: Colors.white,
                value: numberParticipants / widget.event.maxParticipants,
              ),
            ),
          )
        ],
      );
    }
  }
}

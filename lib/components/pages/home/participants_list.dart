import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Participants extends StatefulWidget {
  final Event event;
  final List<User> participants;
   final List<User> possiblyParticipants;
  const Participants(this.event, this.participants, this.possiblyParticipants) : super();

  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  //List<List<User>> participantsList = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    /*EventService()
        .getParticipants(widget.event.id.toString())
        .then((value) => setState(() {
              print("Here");
              participantsList = value;
              loading = false;
            }));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              DateFormat("dd/MM/yyyy HH:mm").format(
                                  DateTime.parse(widget.event.startDate)),
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      buildText(widget.event.maxParticipants),
                      SizedBox(
                        height: 25,
                      ),
                      Divider(
                        height: 5,
                        color: Colors.black,
                        thickness: 1,
                      )
                    ])),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Usuarios que asistirán",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      (!loading)
                          ? (widget.participants.isNotEmpty)
                              ? Column(
                                  children: [
                                    ...widget.participants
                                        .map((participant) => ListTile(
                                              leading: Container(
                                                  width: 45,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          participant
                                                              .profilePicture,
                                                        )),
                                                  )),
                                              title: Text(participant.userName),
                                            ))
                                  ],
                                )
                              : SizedBox()
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(height: 15),
                      Text(
                        "Usuarios en duda",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black54),
                      ),
                      (!loading)
                          ? (widget.possiblyParticipants.isNotEmpty)
                              ? Column(
                                  children: [
                                    ...widget.possiblyParticipants
                                        .map((participant) => ListTile(
                                              leading: Container(
                                                  width: 45,
                                                  height: 45,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          participant
                                                              .profilePicture,
                                                        )),
                                                  )),
                                              title: Text(participant.userName),
                                            ))
                                  ],
                                )
                              : SizedBox()
                          : Center(child: SizedBox())
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildText(int maxParticipants) {
    int numberParticipants = widget.participants.length +
        widget.possiblyParticipants.length;
    if (maxParticipants == -1) {
      String asistentes =
          (numberParticipants == 1) ? " asistente." : " asistentes.";
      return Text(
        numberParticipants.toString() + asistentes,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
      );
    } else {
      String plazasOcupadas =
          (numberParticipants == 1) ? " plaza ocupada." : " plazas ocupadas.";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1.5))),
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                LinearProgressIndicator(
                  minHeight: 30,
                  value: numberParticipants / widget.event.maxParticipants,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      numberParticipants.toString() +
                          "/" +
                          widget.event.maxParticipants.toString() +
                          plazasOcupadas,
                    )),
              ],
            ),
          ),
        ],
      );
    }
  }
}

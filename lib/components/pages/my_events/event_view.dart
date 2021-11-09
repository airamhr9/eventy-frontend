import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/chat/chat_event.dart';
import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/components/pages/home/participants_list.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EventView extends StatefulWidget {
  final Event event;
  const EventView(this.event) : super();

  @override
  _EventView createState() => _EventView();
}

class _EventView extends State<EventView> with TickerProviderStateMixin {
  String userId = "";
  late String date;
  bool isMember = false;

  @override
  void initState() {
    super.initState();
    checkUser();
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
        elevation: 0,
        actions: [
          buildButtonsSaveEnventAndPoint(),
        ],
        automaticallyImplyLeading: true,
      ),
      body: Container(
          color: Theme.of(context).primaryColor,
          child: Material(
              elevation: 0,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Color(0xFFFAFAFA),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  child: NestedScrollView(
                      headerSliverBuilder: (context, boolean) {
                        return [SliverToBoxAdapter(child: buildTop())];
                      },
                      body: Container()),
                ),
              ))),
      floatingActionButton: buildAddToEventButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildTop() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            viewportFraction: 1,
            enableInfiniteScroll: false,
          ),
          items: widget.event.images.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        i,
                        fit: BoxFit.fill,
                      ),
                    ));
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                buildTextParticipants(),
                Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      elevation: 0),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatEvent(widget.event)));
                  },
                  icon: Icon(
                    Icons.chat_rounded,
                    size: 19,
                  ),
                  label: Text(
                    "Chat",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
              buildTextDescription(),
              SizedBox(
                height: 20,
              ),
              buidDateAndLocation(),
              SizedBox(
                height: 15,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Precio",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.lightBlueAccent),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.event.price.toString() + " €",
                  style: TextStyle(fontSize: 16),
                )
              ])
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextParticipants() {
    return TextButton.icon(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Participants(widget.event)));
      },
      icon: Icon(
        Icons.people_rounded,
        size: 28,
      ),
      label: Text(
        (widget.event.maxParticipants == -1)
            ? "Consultar asistentes"
            : "Quedan ${widget.event.maxParticipants - widget.event.participants.length} plazas",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget buildTextDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Descripción",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.lightBlueAccent),
        ),
        SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
            child: Text(
          widget.event.description,
          style: TextStyle(fontSize: 16),
        ))
      ],
    );
  }

  buidDateAndLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fecha y ubicación",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.lightBlueAccent),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "El evento se realizará el " + date,
          style: TextStyle(fontSize: 16),
        ),
        Row(
          children: [
            Text(
              "VALENCIA, ESPAÑA",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            Spacer(),
            TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventLocation(LatLng(
                              widget.event.latitude, widget.event.longitude))));
                },
                label: Text("Ver en mapa"),
                icon: Icon(Icons.place_rounded))
          ],
        ),
      ],
    );
  }

  Widget buildButtonsSaveEnventAndPoint() {
    if (isMember == true) {
      return Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.star_rounded)),
          IconButton(
              onPressed: () {
                EventService().saveEvent(widget.event.id).then((value) {
                  if (value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Evento guardado"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                    ));
                  }
                });
              },
              icon: Icon(Icons.favorite_rounded))
        ],
      );
    } else {
      return IconButton(
          onPressed: () {
            EventService().saveEvent(widget.event.id).then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Evento guardado"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                ));
              }
            });
          },
          icon: Icon(Icons.favorite_rounded));
    }
  }

  buildAddToEventButton() {
    return Visibility(
      child: FloatingActionButton.extended(
        icon: Icon(Icons.person_add),
        label: Text("Unirse"),
        onPressed: () {
          showEventDialog();

          dialogAddToEvent();
        },
      ),
      visible: !isMember,
    );
  }

  dialogAddToEvent() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Te has unido con exito",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black87),
            ),
            actionsPadding: EdgeInsets.only(left: 10),
            actionsAlignment: MainAxisAlignment.start,
            actions: [
              TextButton(
                  child: Text(
                    "Aceptar",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(
                        context,
                      ))
            ],
          );
        });
  }

  Future<bool> checkUser() async {
    userId = await MySharedPreferences.instance.getStringValue("userId");
    for (String userIdInEvent in widget.event.participants) {
      if (userId == userIdInEvent) {
        return isMember = true;
      }
    }
    return isMember;
  }

  void showEventDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),

              child: Container(
                  padding:  const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  width: 150,
                  height: 249,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unirse al evento",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Opciones de asistencia",
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      TextButton.icon(
                          icon: Icon(
                            Icons.check,
                            color: Colors.greenAccent,
                          ),
                          onPressed: () {
                            addMemberToEvent("true");
                            Navigator.of(context).pop();
                          },
                          label: Text(
                            "Iré Seguro",
                            style: TextStyle(color: Colors.lightBlue),
                          )),
                      const Divider(
                        //height: 20,
                        thickness: 1,
                        indent: 1,
                        endIndent: 1,
                      ),
                      TextButton.icon(
                          icon: Icon(Icons.av_timer_rounded,
                              color: Colors.orangeAccent),
                          onPressed: () {
                            addMemberToEvent("false");
                            Navigator.of(context).pop();
                          },
                          label: Text(
                            "Quizás",
                            style: TextStyle(color: Colors.lightBlue),
                          )),

                      const Divider(
                        //height: 20,
                        thickness: 1,
                        indent: 1,
                        endIndent: 1,
                      ),

                      TextButton.icon(
                          icon: Icon(Icons.cancel_rounded,
                              color: Colors.redAccent),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          label: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.lightBlue),
                          ))
                    ],
                  )));
        });
  }
  addMemberToEvent(String confirmed) async {
    EventService().sendNewParticipant(widget.event.id.toString(),
        await MySharedPreferences.instance.getStringValue("userId"), confirmed);
  }
}

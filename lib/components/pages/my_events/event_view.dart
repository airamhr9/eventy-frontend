import 'dart:isolate';
import 'package:eventy_front/components/pages/my_events/create_poll.dart';
import 'package:eventy_front/objects/poll.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/chat/chat_event.dart';
import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/components/pages/home/participants_list.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/events_service.dart';
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
  late String date;
  late bool isMember;
  bool waitComplete = false;
  late num score;
  late String userId;
  List<Poll> surveysList = [];

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance
        .getStringValue("userId")
        .then((value) => setState(() {
              userId = value;
              waitToCheck();
            }));
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
  }

  @override
  Widget build(BuildContext context) {
    if (waitComplete == true)
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
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
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
        floatingActionButton: buildFlotaingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }

  waitToCheck() {
    try {
      isMember = widget.event.participants.contains(userId);
    } catch (e) {
      //contains devuelve null si el usuario no es un particpante
      isMember = false;
    }
    if (isMember == true) {
      getScores();
    } else {
      setState(() {
        isMember = false;
        waitComplete = true;
      });
    }
  }

  getScores() {
    EventService()
        .getUserScoreAndEventAverage(widget.event.id.toString(), userId)
        .then((list) => setState(() {
              waitComplete = true;
              isMember = true;
              score = list[0];
              widget.event.averageScore = list[1];
            }));
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
                Spacer(),
                buildTextParticipantsAndScoreEvent(),
                Spacer(),
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
              ]),
              SizedBox(
                height: 15,
              ),
              //buildSurveys()
            ],
          ),
        ),
      ],
    );
  }

  buildTextParticipantsAndScoreEvent() {
    if (widget.event.averageScore != 0.0 &&
        widget.event.finishDate.compareTo(DateTime.now().toString()) < 0) {
      return Row(
        children: [
          buildTextParticipants(),
          SizedBox(
            width: 60,
          ),
          Text(widget.event.averageScore.toString()),
          Icon(
            Icons.star_rounded,
            color: Colors.orange,
          ),
        ],
      );
    } else {
      return buildTextParticipants();
    }
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
              "VALENCIA, ESPAÑA  ",
              style: TextStyle(fontSize: 15),
            ),
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

  buildButtonsSaveEnventAndPoint() {
    if (isMember == true &&
        widget.event.finishDate.compareTo(DateTime.now().toString()) < 0) {
      return Row(
        children: [
          IconButton(
              onPressed: () {
                pointEvent();
              },
              icon: Icon(Icons.star_rounded)),
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
              icon: Icon(Icons.bookmark_add_rounded))
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
          icon: Icon(Icons.bookmark_add_rounded));
    }
  }

  buildFlotaingButton() {
    if (isMember == true) {
      return FloatingActionButton.extended(
        icon: Icon(Icons.chat_rounded),
        label: Text("Chat"),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatEvent(widget.event)));
        },
      );
    } else {
      return FloatingActionButton.extended(
        icon: Icon(Icons.person_add),
        label: Text("Unirse"),
        onPressed: () {
          showEventDialog();
        },
      );
    }
  }

  void showEventDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              child: Container(
                  padding: const EdgeInsets.all(10.0),
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

  pointEvent() {
    if (score != -1) {
      buildTextScore(score);
    } else {
      score = 0;
      buildTextScore(score);
    }
  }

  buildTextScore(num scoreUser) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  width: 150,
                  height: 165,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black87),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildRatingBar(scoreUser),
                      SizedBox(
                        height: 10,
                      ),
                      Spacer(),
                      TextButton.icon(
                          onPressed: () {
                            EventService().postUserScore(
                                widget.event.id.toString(),
                                userId,
                                score.toString());
                            setState(() {});
                            Navigator.of(context).pop();
                            buildMessageThanks();
                          },
                          label: Text("Guardar puntuación"),
                          icon: Icon(Icons.save_rounded))
                    ],
                  )));
        });
  }

  Widget buildRatingBar(num scoreUser) {
    return RatingBar(
        initialRating: scoreUser.toDouble(),
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        ratingWidget: RatingWidget(
            full: Icon(Icons.star, color: Colors.orange),
            half: Icon(
              Icons.star_half,
              color: Colors.orange,
            ),
            empty: Icon(
              Icons.star_outline,
              color: Colors.orange,
            )),
        onRatingUpdate: (value) {
          setState(() {
            score = value;
          });
        });
  }

  buildMessageThanks() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                height: 100,
                width: 165,
                child: Text(
                  "Puntuación guardada correctamente!",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black87),
                ),
              ));
        });
  }

  buildSurveys() {
    //Polls son encuestas XD
    if (surveysList.isNotEmpty && widget.event.participants.contains(userId)) {
      return Container(
        child: Column(
          children: [
            Text("ENCUESTAS"),
            buildButtonAddSurvey(),
          ],
        ),
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  buildButtonAddSurvey() {
    if (widget.event.ownerId == userId) {
      return ElevatedButton(
          onPressed: () {
            // Llamada a creacion de encuesta
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return CreateSurvey(widget.event.id.toString());
            }));
          },
          child: Text("Añadir"));
    } else {
      return SizedBox(height: 1);
    }
  }

  buildSurveyData() {
    Column(
      children: [
        // ACABAR /////////////////
      ],
    );
  }
}

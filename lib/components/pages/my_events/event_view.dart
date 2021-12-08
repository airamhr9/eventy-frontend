import 'dart:developer';
import 'dart:isolate';
import 'package:eventy_front/components/pages/my_events/related_event_card.dart';
import 'package:eventy_front/components/pages/my_events/related_events.dart';
import 'package:eventy_front/components/pages/my_events/add_survey.dart';
import 'package:eventy_front/components/widgets/comment.dart';
import 'package:eventy_front/components/widgets/filled_button.dart';
import 'package:eventy_front/components/widgets/moving_title.dart';
import 'package:eventy_front/components/widgets/border_button.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/survey.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/chat_service.dart';
import 'package:eventy_front/services/user_service.dart';
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
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';

import 'event_memories.dart';

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
  List<Survey> surveysList = [];
  String _visibilityValue = "option0";
  late String priceText;
  late String plazasText;
  late String plazasCounter;
  List<Message> comments = [];
  bool hasComments = false;
  late User user;
  bool hasUser = false;

  bool showDate = true;

  String optionVoted = "";
  bool reloadSurveys = false;
  List<List<User>> participantsList = [];
  //bool loading = true;
  List<String> participantsId = [];

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance.getStringValue("userId").then((value) {
      setState(() {
        userId = value;
      });
      _fetch();
      waitToCheck();
    });
    priceText = (widget.event.price > 0)
        ? widget.event.price.toString() + "\$"
        : "Gratis";
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
    plazasText = (widget.event.maxParticipants != -1)
        ? "Quedan ${widget.event.maxParticipants - widget.event.participants.length} plazas"
        : "No hay límite de plazas";
    plazasCounter = (widget.event.maxParticipants != -1)
        ? "${widget.event.participants.length}/${widget.event.maxParticipants}"
        : "";
    EventService().getSurveys(widget.event.id.toString()).then((value) {
      setState(() {
        surveysList = value;
        for (Survey s in surveysList) {
          if (s.question == "¿Qué fecha prefieres?") {
            showDate = false;
            break;
          }
        }
      });
    });
  }

  _fetch() async {
    final results = await Future.wait([
      ChatService().getEventMessages(widget.event.id),
      UserService().getUser(userId),
    ]);

    setState(() {
      comments.addAll(results[0] as List<Message>);
      comments = comments.reversed.toList();
      hasComments = true;
    });
    setState(() {
      user = results[1] as User;
      hasUser = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (waitComplete == true)
      return Scaffold(
        appBar: AppBar(
          title: Text("OnPoint"),
          elevation: 0,
          actions: [
            buildButtonsSaveEnventAndPoint(),
          ],
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFFAFAFA),
          foregroundColor: Colors.black,
        ),
        body: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 1))),
          child: SingleChildScrollView(child: buildTop()),
        ),
      );
    else
      return Container(
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()),
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
              widget.event.averageScore = 0;
            }));
  }

  Widget buildTop() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          SizedBox(
            height: 55,
            child: MovingTitle(widget.event.name),
          ),
          SizedBox(
            height: 20,
          ),
          FilledButton(text: "Unirse", onPressed: () => showEventDialog()),
          SizedBox(
            height: 30,
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 230.0,
              viewportFraction: 1,
              enableInfiniteScroll: false,
            ),
            items: widget.event.images.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        child: Image.network(
                          i,
                          fit: BoxFit.fitWidth,
                        ),
                      ));
                },
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border(
                          top: BorderSide(color: Colors.black, width: .8),
                          bottom: BorderSide(color: Colors.black, width: .8)),
                    )),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.event.address),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventLocation(LatLng(
                                      widget.event.latitude,
                                      widget.event.longitude))));
                        },
                        child: Text(
                          "Ver en mapa",
                          style: TextStyle(color: Colors.black45),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          child: Text(
                            widget.event.description,
                            style: TextStyle(color: Colors.black54),
                          )),
                      buildTextDate(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  height: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      priceText,
                      style: TextStyle(
                          fontFamily: 'Tiny',
                          fontSize: 35,
                          color: Colors.black),
                    ),
                    BorderButton(
                        text: "Participantes",
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Participants(widget.event))))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                  value: widget.event.participants.length /
                      widget.event.maxParticipants,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(plazasText), Text(plazasCounter)],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Hablemos",
                  style: TextStyle(
                      fontFamily: 'Tiny', fontSize: 30, color: Colors.black),
                ),
                TextButton(
                    child: Text(
                      "Comentar",
                      style: TextStyle(color: Colors.black54, fontSize: 20),
                    ),
                    onPressed: (hasUser)
                        ? () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  TextEditingController commentController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text("Comentar"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            "Cancelar",
                                            style: TextStyle(
                                                color: Colors.black54),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            String messageText =
                                                commentController.text.trim();
                                            if (messageText.isNotEmpty) {
                                              Message newMessage = Message(
                                                  "",
                                                  messageText,
                                                  DateTime.now(),
                                                  user.id,
                                                  user.userName,
                                                  user.profilePicture);
                                              Navigator.pop(context);
                                              setState(() {
                                                comments.insert(0, newMessage);
                                              });
                                              Message messageToSend = Message(
                                                  newMessage.id,
                                                  newMessage.text,
                                                  newMessage.dateTime,
                                                  newMessage.userId,
                                                  newMessage.userName,
                                                  user.profilePictureName!);
                                              ChatService().sendMessageEvent(
                                                  messageToSend,
                                                  widget.event.id);
                                            }
                                          },
                                          child: Text(
                                            "Comentar",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                    ],
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 10),
                                      child: TextField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        controller: commentController,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                bottom: 25, left: 15),
                                            fillColor: Colors.white70,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 1)),
                                            filled: true,
                                            hintText: "Comentario"),
                                      ),
                                    ),
                                  );
                                });
                          }
                        : null)
              ],
            ),
          ),
          (!hasComments)
              ? CircularProgressIndicator()
              : (comments.length > 0)
                  ? Column(
                      children: [...comments.map((e) => Comment(e))],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("No hay comentarios aún"),
                      ],
                    ),
          buildSurveys(),
          SizedBox(
            height: 20,
          ),
          buildMemories(),
          SizedBox(
            height: 20,
          ),
          SizedBox(height: 250, child: RelatedEvents(widget.event)),
          SizedBox(
            height: 10,
          ),
          /*  Container(
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
          ), */
        ],
      ),
    );
  }

  /*buildTextParticipantsAndScoreEvent() {
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
  }*/

  /*Widget buildTextParticipants() {
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
  }*/

  /*Widget buildTextDescription() {
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
  }*/

  /*buidDateAndLocation() {
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
  }*/

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
              icon: Icon(Icons.bookmark_add))
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
          icon: Icon(Icons.bookmark_add));
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
                  height: 255,
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
                          icon:
                              Icon(Icons.av_timer, color: Colors.orangeAccent),
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
                          icon: Icon(Icons.cancel, color: Colors.redAccent),
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

  Widget buildSurveys() {
    if ((surveysList.isNotEmpty &&
            widget.event.participants.contains(userId)) ||
        widget.event.ownerId == userId) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Encuestas",
                  style: TextStyle(
                      fontFamily: 'Tiny', fontSize: 30, color: Colors.black),
                ),
                buildButtonAddSurvey(),
              ],
            ),
            buildSurveyDataOrOptionsToVote(),
          ],
        ),
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  buildButtonAddSurvey() {
    if (widget.event.ownerId == userId) {
      return Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: TextButton(
              child: Text(
                "Añadir",
                style: TextStyle(color: Colors.black54, fontSize: 20),
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddSurvey(widget.event.id)))));
    } else {
      return SizedBox(height: 10);
    }
  }

  Widget buildSurveyDataOrOptionsToVote() {
    if (surveysList.isNotEmpty) {
      return Column(
        children: [
          ...surveysList.map((survey) {
            // NO BORRAR ESTE CODIGO
            //if (survey.startDate.compareTo(DateTime.now().toString()) > 0 &&
            //survey.finishDate.compareTo(DateTime.now().toString()) < 0) {
            if (survey.userHasVoted == true) {
              return buildDataOption(survey);
            } else {
              return buildOptions(survey);
            }
            /*} else {
              return SizedBox(
                height: 0,
              );
            }*/
          })
        ],
      );
    } else {
      return Container(
          alignment: AlignmentDirectional.center,
          child: (Text("No hay encuestas aún")));
    }
  }

  Widget buildDataOption(Survey survey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          survey.question,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            ...survey.options.map((option) {
              num percentage = option['percentage'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option['text'].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                        child: LinearProgressIndicator(
                          color: Colors.orange,
                          value: percentage / 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child:
                            Container(child: Text(percentage.toString() + "%")),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
          ],
        ),
        Text("Han votado " +
            survey.numVotes.toString() +
            "/" +
            widget.event.participants.length.toString())
      ],
    );
  }

  Widget buildOptions(Survey survey) {
    int count = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(survey.question, style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 5,
        ),
        Column(
          children: [
            ...survey.options.map((option) {
              count++;
              return RadioButton(
                description: option['text'].toString(),
                value: "option" + count.toString(),
                groupValue: _visibilityValue,
                onChanged: (value) {
                  setState(() {
                    _visibilityValue = value as String;
                    optionVoted = option['text'].toString();
                  });
                },
              );
            }),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.centerRight,
            child: TextButton(
                child: Text(
                  "Votar",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                onPressed: () {
                  if (_visibilityValue != "option0") {
                    EventService()
                        .postSurveyVote(
                            widget.event.id.toString(), survey.id, optionVoted)
                        .then((value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    super.widget)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Debe de elegir una opción"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 1),
                    ));
                  }
                }))
      ],
    );
  }

  Widget buildTextDate() {
    if (showDate == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Transform.rotate(
            angle: -.2,
            child: VerticalDivider(
              thickness: 1,
              color: Colors.black,
            ),
          ),
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date.substring(0, 10),
                  style: TextStyle(
                      fontFamily: 'Tiny', fontSize: 20, color: Colors.black),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                Text(
                  date.substring(10, date.length),
                  style: TextStyle(
                      fontFamily: 'Tiny', fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }

  Widget buildMemories() {
    if (widget.event.finishDate.compareTo(DateTime.now().toString()) < 0 &&
        widget.event.participants.contains(userId)) {
      return EventsMemories(widget.event);
    } else {
      return SizedBox(
        height: 5,
      );
    }
  }
}

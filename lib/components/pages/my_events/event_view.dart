import 'dart:isolate';
import 'package:eventy_front/components/pages/my_events/create_survey.dart';
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
  String _visibilityValue = "option1";
  late String priceText;
  late String plazasText;
  late String plazasCounter;
  List<Message> comments = [];
  bool hasComments = false;
  late User user;
  bool hasUser = false;

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
    priceText =
        (widget.event.price > 0) ? widget.event.price.toString() : "Gratis";
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
    plazasText = (widget.event.maxParticipants != -1)
        ? "Quedan ${widget.event.maxParticipants - widget.event.participants.length} plazas"
        : "No hay límite de plazas";
    plazasCounter = (widget.event.maxParticipants != -1)
        ? "${widget.event.participants.length}/${widget.event.maxParticipants}"
        : "";
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
              border: Border(top: BorderSide(color: Colors.black, width: .8))),
          padding: EdgeInsets.only(top: 5),
          child: SingleChildScrollView(child: buildTop()),
        ),
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
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          SizedBox(
            height: 55,
            child: MovingTitle(widget.event.name),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                FilledButton(text: "Unirse", onPressed: showEventDialog),
                SizedBox(
                  height: 30,
                ),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
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
                    Text("Casa Luz Mª. Valencia"),
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
                                  fontFamily: 'Tiny',
                                  fontSize: 45,
                                  color: Colors.black),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            Text(
                              date.substring(10, date.length),
                              style: TextStyle(
                                  fontFamily: 'Tiny',
                                  fontSize: 45,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
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
                          fontSize: 80,
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
                      fontFamily: 'Tiny', fontSize: 80, color: Colors.black),
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
              : Column(
                  children: [...comments.map((e) => Comment(e))],
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
    if ((surveysList.isNotEmpty &&
            widget.event.participants.contains(userId)) ||
        widget.event.ownerId == userId) {
      return Container(
        child: Column(
          children: [
            Text("ENCUESTAS"),
            buildButtonAddSurvey(),
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
      return ElevatedButton(
          onPressed: () {
            // Llamada a creacion de encuesta
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return CreateSurvey();
            }));
          },
          child: Text("Añadir"));
    } else {
      return SizedBox(height: 1);
    }
  }

  buildSurveyDataOrOptionsToVote() {
    bool userAlreadyVote = false;
    int count = 0;
    for (Survey survey in surveysList) {
      for (List<String> userVoteList
          in survey.options[count] <= survey.options.length) {
        count++;
        if (userVoteList.contains(userId)) {
          userAlreadyVote = true;
          break;
        }
        /*if (count == survey.options.length) { // Si ya no hay mas opciones
          break;
        }*/
      }
      if (userAlreadyVote == true) {
        // Si el usuario ha votado alguna opcion
        buildDataOption(survey);
      } else {
        // Si el usuario NO ha votado
        buildOptions(survey);
      }
    }
  }

  buildDataOption(Survey survey) {
    Text(survey.name);
    for (List option in survey.options) {
      Column(
        children: [
          Text(option[0].toString()),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  color: Colors.orange,
                  value: option[2],
                ),
              ),
            ],
          ),
        ],
      );
    }
    Text("Han votado " +
        survey.numVotes.toString() +
        "/" +
        widget.event.participants.length.toString());
  }

  buildOptions(Survey survey) {
    int count = 0;
    Text(survey.name);
    for (List option in survey.options) {
      count++;
      Column(
        children: [
          RadioButton(
            description: option[0].toString(),
            value: "option" + count.toString(),
            groupValue: _visibilityValue,
            onChanged: (value) {
              setState(() {
                _visibilityValue = value as String;
              });
            },
          ),
        ],
      );
    }
    ElevatedButton(
        onPressed: () {
          // VOTACION DEL USUSARIO
        },
        child: Text("Votar"));
  }
}

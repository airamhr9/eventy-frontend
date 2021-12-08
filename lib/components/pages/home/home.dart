import 'dart:async';

import 'package:eventy_front/components/pages/home/recomendation.dart';
import 'package:eventy_front/components/pages/my_events/event_card.dart';
import 'package:eventy_front/components/widgets/moving_title.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class Home extends StatefulWidget {
  final _HomeState homeState = _HomeState();

  @override
  _HomeState createState() {
    return homeState;
  }
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Color> colors = [Colors.black, Colors.red, Colors.blue, Colors.green];
  List<Event> events = [];
  late Event currentEvent;
  late Event currentMapEvent;
  List<User> participants = [];
  List<User> possiblyParticipants = [];
  late TabController _tabController = TabController(length: 2, vsync: this);
  final List<Widget> myTabs = [
    Tab(text: 'Tarjetas'),
    Tab(text: 'Mapa'),
  ];
  Completer<GoogleMapController> _controller = Completer();
  LatLng selectedLocation = LatLng(37.42796133580664, 1.085749655962);
  List<Marker> myMarker = [];
  late final initialPos;

  @override
  void initState() {
    super.initState();
    EventService().get().then((value) => setState(() {
          print("Here");
          events = value;
          currentEvent = events.first;
          currentMapEvent = events.first;
          initialPos = CameraPosition(
            target: LatLng(events.first.latitude, events.first.longitude),
            zoom: 14.4746,
          );
          myMarker = events
              .map((e) => Marker(
                  markerId: MarkerId(e.id.toString()),
                  position: LatLng(e.latitude, e.longitude),
                  onTap: () => setState(() {
                        currentMapEvent = e;
                      })))
              .toList();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return events.length > 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 10,
                ),
                TabBar(
                  indicator: MaterialIndicator(
                    color: Theme.of(context).primaryColor,
                    horizontalPadding: 80,
                    topLeftRadius: 20,
                    topRightRadius: 20,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  labelColor: Colors.black87,
                  controller: _tabController,
                  isScrollable: false,
                  tabs: myTabs,
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      buildRecomendationsTab(),
                      buildMapRecomendations()
                    ],
                  ),
                )
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget buildMapRecomendations() {
    return Column(children: [
      SizedBox(
        height: 20,
      ),
      SizedBox(
        height: 400,
        child: GoogleMap(
          markers: Set.from(myMarker),
          mapType: MapType.normal,
          initialCameraPosition: initialPos,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onTap: _onMapTapped,
        ),
      ),
      Expanded(
        child: Column(
          children: [EventCard(currentMapEvent)],
        ),
      )
    ]);
  }

  _onMapTapped(LatLng location) {
    print(location);
    setState(() {
      selectedLocation = location;
    });
  }

  Widget buildRecomendationsTab() {
    return Column(
      children: [
        SizedBox(
          height: 55,
          child: MovingTitle("● Eventos para ti"),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: TikTokStyleFullPageScroller(
            contentSize: events.length,
            swipePositionThreshold: 0.1,
            swipeVelocityThreshold: 500,
            animationDuration: const Duration(milliseconds: 200),
            builder: (BuildContext context, int index) {
              return RecommendedEvent(events[index]);
            },
            onScrollEvent: _handleCallbackEvent,
          ),
        ),
      ],
    );
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    if (currentIndex != null) {
      setState(() {
        currentEvent = events[currentIndex];
        _loadParticipants();
      });
    }
  }

  void _loadParticipants() {
    EventService()
        .getParticipants(currentEvent.id.toString())
        .then((value) => setState(() {
              print(value.toString());
              participants = value[0];
              possiblyParticipants = value[1];
              print("cargando usuarios");
              print("participantes");
              print(participants);
              print("posible");
              print(possiblyParticipants);
              print(participants.toString());
              print("usuarios cargados");
            }));
  }

  addMemberToEvent(bool confirmed, BuildContext context) async {
    if (currentEvent.participants.length >= currentEvent.maxParticipants) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("El evento ya está completo y no es posible unirse")));
      return;
    }
    EventService().sendNewParticipant(currentEvent.id.toString(),
        await MySharedPreferences.instance.getStringValue("userId"), confirmed);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Te has unido al evento",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black87),
            ),
            content:
                Text("Puedes encontrar el evento en la pantalla: Mis eventos."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Vale",
                    style: TextStyle(color: Colors.lightBlue),
                  ))
            ],
          );
        });

    EventService().get().then((value) => setState(() {
          print("Here");
          events = value;
          currentEvent = events.first;
        }));
  }

  saveEvent() {
    try {
      if (events.length > 0) {
        EventService().saveEvent(currentEvent.id).then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Evento guardado"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ));
          }
        });
      }
    } catch (lateInitializationError) {
      print("No object yet");
    }
  }

  buildMessageAddEvent(BuildContext context) async {
    _loadParticipants();
    String myUserId =
        await MySharedPreferences.instance.getStringValue("userId");

    bool userIsParticpant = false;

    if ((participants.where((element) => element.id == myUserId).length) > 0)
      userIsParticpant = true;

    if ((possiblyParticipants
            .where((element) => element.id == myUserId)
            .length) >
        0) userIsParticpant = true;

    if (userIsParticpant == true) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Ya estas en este evento",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black87),
              ),
              content: Text(
                  "Puedes encontrar el evento en la pantalla: Mis eventos."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Vale",
                      style: TextStyle(color: Colors.lightBlue),
                    ))
              ],
            );
          });
    } else {
      showJoinEventDialog(context);
    }
  }

  void showJoinEventDialog(BuildContext context) {
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
                            addMemberToEvent(true, context);

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
                            addMemberToEvent(false, context);
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
}

import 'package:eventy_front/components/pages/friends/group_recomendation_events.dart';
import 'package:eventy_front/components/pages/friends/recomended_event_card.dart';
import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/objects/user_group.dart';
import 'package:eventy_front/services/group_service.dart';
import 'package:eventy_front/services/tags_service.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class GroupDetail extends StatefulWidget {
  final Group group;
  final String userId;
  const GroupDetail(this.group, this.userId, {Key? key}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  List<String> filterTags = [];
  String minDate = "";
  String maxDate = "";
  TextEditingController minDateController = TextEditingController();
  TextEditingController maxDateController = TextEditingController();
  double _currentPriceValue = 100;
  List<User> friends = [];
  bool hasFriendsResponse = false;
  Map<String, bool> sendInvites = {};
  late UserGroup currentUser;
  late bool currentUserIsCreator;

  Map<UserGroup, bool> users = {};

  @override
  void initState() {
    super.initState();
    currentUser =
        widget.group.users.firstWhere((element) => element.id == widget.userId);
    currentUserIsCreator = currentUser.id.compareTo(widget.group.creator) == 0;
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (currentUser.dateMin != "") {
      setState(() {
        minDate = currentUser.dateMin;
        minDateController.text = formatter.format(DateTime.parse(minDate));
      });
    }
    if (currentUser.dateMax != "") {
      setState(() {
        maxDate = currentUser.dateMax;
        maxDateController.text = formatter.format(DateTime.parse(maxDate));
      });
    }
    if (currentUser.price != "") {
      setState(() {
        _currentPriceValue = double.parse(currentUser.price);
      });
    }
    if (currentUser.tags != []) {
      setState(() {
        filterTags = currentUser.tags;
      });
    }
  }

  void _fetchFriends(StateSetter setModalState) async {
    if (friends.isEmpty) {
      UserService().getFriends(widget.userId).then((value) {
        List<String> userIds = widget.group.users.map((e) => e.id).toList();
        List<User> friendsAux =
            value[0].where((friend) => !userIds.contains(friend.id)).toList();
        Iterable<String> friendsIds = friendsAux.map((e) => e.id);
        Map<String, bool> mapAux = Map.fromIterables(
            friendsIds, Iterable.generate(friendsAux.length, (index) => false));
        setModalState(() {
          friends = friendsAux;
          sendInvites = mapAux;
          hasFriendsResponse = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.blue[500],
        body: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 15, right: 10, left: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Participantes",
                              style: TextStyle(fontSize: 17),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showFriendsDialog();
                              },
                              icon: Icon(Icons.person_add_rounded),
                              label: Text("Invitar"),
                            )
                          ]),
                      ...widget.group.users.map((e) => buildParticipantTile(e)),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tus preferencias",
                              style: TextStyle(fontSize: 17),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                savePreferences();
                                showFriendsDialog();
                              },
                              icon: Icon(Icons.save_rounded),
                              label: Text("Guardar"),
                            )
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                                readOnly: true,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now(),
                                      maxTime: DateTime.now()
                                          .add(Duration(days: 730)),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                    setState(() {
                                      final DateFormat formatter =
                                          DateFormat('dd/MM/yyyy');
                                      final String formatted =
                                          formatter.format(date);
                                      minDate = date.toIso8601String();
                                      currentUser.dateMin = minDate;
                                      minDateController.text = formatted;
                                    });
                                  });
                                },
                                decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.calendar_today_rounded),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    hintText: "Mínima"),
                                controller: minDateController),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                                readOnly: true,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now(),
                                      maxTime: DateTime.now()
                                          .add(Duration(days: 730)),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                    setState(() {
                                      final DateFormat formatter =
                                          DateFormat('dd/MM/yyyy');
                                      final String formatted =
                                          formatter.format(date);
                                      maxDate = date.toIso8601String();
                                      currentUser.dateMax = maxDate;
                                      maxDateController.text = formatted;
                                    });
                                  });
                                },
                                decoration: InputDecoration(
                                    prefixIcon:
                                        Icon(Icons.calendar_today_rounded),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    hintText: "Máxima"),
                                controller: maxDateController),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("Presupuesto"),
                          Expanded(
                            child: Slider(
                              value: _currentPriceValue,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              label: _currentPriceValue.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _currentPriceValue = value;
                                  currentUser.price =
                                      _currentPriceValue.toString();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                          future: TagsService().get(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              List<String> tagList =
                                  snapshot.data as List<String>;
                              return Container(
                                  child: Wrap(
                                spacing: 5,
                                runSpacing: 3,
                                children: [
                                  ...tagList.map((tag) => FilterChip(
                                        label: Text(tag),
                                        selected: filterTags.contains(tag),
                                        selectedColor: Colors.lightBlue[100],
                                        onSelected: (bool selected) {
                                          setState(() {
                                            if (selected) {
                                              filterTags.add(tag);
                                            } else {
                                              filterTags.remove(tag);
                                            }
                                          });
                                        },
                                      ))
                                ],
                              ));
                            } else
                              return Center(child: CircularProgressIndicator());
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity,
                                  40), // double.infinity is the width and 30 is the height
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupRecomendedEvents(
                                        widget.group, currentUserIsCreator)));
                          },
                          child: Text("Recomendaciones actuales")),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  void savePreferences() {
    Map<String, dynamic> filters = {};
    filters["userId"] = widget.userId;
    filters["validPreferences"] = true;
    if (currentUser.price != "") filters['price'] = currentUser.price;
    if (currentUser.dateMin != "") filters['dateMin'] = currentUser.dateMin;
    if (currentUser.dateMax != "") filters['dateMax'] = currentUser.dateMax;
    if (currentUser.tags != []) filters['tags'] = currentUser.tags;
    setState(() {
      currentUser.validPreferences = true;
    });
    GroupService().updateUser(widget.group.id, filters);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Tus preferencias se han actualizado"),
      backgroundColor: Colors.green,
    ));
  }

  void showFriendsDialog() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            _fetchFriends(setModalState);

            return Container(
              height: 550,
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: (hasFriendsResponse)
                  ? ListView(
                      children: [
                        Text(
                          "Invitar amigos",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ...friends.map((friend) => ListTile(
                              leading: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          friend.profilePicture,
                                        )),
                                  )),
                              title: Text(friend.userName),
                              trailing: Checkbox(
                                value: sendInvites[friend.id],
                                onChanged: (value) {
                                  setModalState(() {
                                    sendInvites[friend.id] = value!;
                                  });
                                },
                              ),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity,
                                    40), // double.infinity is the width and 30 is the height
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              sendInvitations();
                            },
                            child: Text("Enviar invitaciones")),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            );
          });
        });
  }

  Widget buildParticipantTile(UserGroup user) {
    Icon icon = (user.validPreferences)
        ? Icon(
            Icons.check_rounded,
            color: Colors.green,
          )
        : Icon(
            Icons.timer_rounded,
            color: Colors.orange,
          );
    return ListTile(
      leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  user.imageUrl,
                )),
          )),
      title: Text(user.username),
      trailing: icon,
    );
  }

  void sendInvitations() {
    GroupService().sendInvite(
        widget.group.id,
        sendInvites.keys
            .where((element) => sendInvites[element] == true)
            .toList());

    setState(() {
      sendInvites.keys.forEach((element) {
        sendInvites[element] = false;
      });
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Invitaciones enviadas"),
      backgroundColor: Colors.green,
    ));
  }
}

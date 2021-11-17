import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/objects/user_group.dart';
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
  DateTime minDate = DateTime.now();
  DateTime maxDate = DateTime.now();
  TextEditingController minDateController = TextEditingController();
  TextEditingController maxDateController = TextEditingController();
  double _currentSliderValue = 0;
  List<User> friends = [];
  bool hasFriendsResponse = false;

  Map<UserGroup, bool> users = {};

  @override
  void initState() {
    super.initState();
    users = new Map.fromIterable(widget.group.users,
        key: (v) => v, value: (v) => false);
    _fetchFriends();
  }

  void _fetchFriends() async {
    UserService().getFriends(widget.userId).then((value) => setState(() {
          friends = value[0];
          hasFriendsResponse = true;
        }));
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
            padding: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 15),
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
                      ...users.keys
                          .map((e) => buildParticipantTile(users[e]!, e)),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tus preferencias",
                              style: TextStyle(fontSize: 17),
                            ),
                            TextButton.icon(
                              onPressed: () {},
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
                                      minDate = date;
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
                                      maxDate = date;
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
                              value: _currentSliderValue,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              label: _currentSliderValue.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _currentSliderValue = value;
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
                          onPressed: () {},
                          child: Text("Recomendaciones actuales")),
                    ],
                  )
                ],
              ),
            )));
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
            return Container(
              height: 550,
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ListView(
                children: [
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
                        trailing: Container(),
                      ))
                ],
              ),
            );
          });
        });
  }

  Widget buildParticipantTile(bool allOptionsSet, UserGroup user) {
    Icon icon = (allOptionsSet)
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
}

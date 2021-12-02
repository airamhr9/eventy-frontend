import 'package:eventy_front/components/pages/friends/friends.dart';
import 'package:eventy_front/components/pages/friends/groups.dart';
import 'package:eventy_front/components/pages/my_events/my_events.dart';
import 'package:eventy_front/components/pages/profile/profile_edit.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Profile extends StatefulWidget {
  const Profile() : super();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  List<String> tags = [];
  late TabController _tabController = TabController(length: 3, vsync: this);
  final List<Widget> myTabs = [
    Tab(text: 'Próximamente'),
    Tab(text: 'Historial'),
    Tab(text: 'Ver más tarde'),
  ];
  String userId = "";
  User user = User(
      "-1",
      "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fusers%2FuserImg.jpg?alt=media&token=9a12a294-94c9-4e76-8eae-86a17054bbe0",
      "",
      [],
      "CARGANDO",
      "",
      "",
      "",
      "userImage.jpg");

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance.getStringValue("userId").then((value) {
      setState(() {
        userId = value;
      });

      print("id" + userId);
      UserService().getUser(userId).then((value) => setState(() {
            user = value;
          }));

      UserService().getUserPreferences(userId, "").then((value) => setState(() {
            print("Here " + userId);
            tags = value;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return (NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverToBoxAdapter(child: buildProfile()),
        SliverAppBar(
            primary: false,
            toolbarHeight: 0,
            backgroundColor: Color(0xFFFAFAFA),
            elevation: 0,
            pinned: true,
            bottom: TabBar(
              indicator: MaterialIndicator(
                color: Theme.of(context).primaryColor,
                horizontalPadding: 40,
                topLeftRadius: 20,
                topRightRadius: 20,
                paintingStyle: PaintingStyle.fill,
              ),
              labelColor: Colors.black87,
              controller: _tabController,
              isScrollable: false,
              tabs: myTabs,
            )),
      ],
      body: MyEvents(_tabController),
    ));
  }

  Container buildProfile() {
    return Container(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: -40,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 132,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePicture),
                      backgroundColor: Colors.black,
                      radius: 130,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          user.userName,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Friends(userId)));
                            },
                            icon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Mis amigos",
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Groups(userId)));
                            },
                            icon: Icon(
                              Icons.group,
                              color: Colors.black,
                            ),
                            label: Text("Mis Grupos",
                                style: TextStyle(color: Colors.black))),
                        TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProfileEdit()));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            label: Text("Editar perfil",
                                style: TextStyle(color: Colors.black))),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          child: Text(
                            user.bio,
                            style: TextStyle(color: Colors.black54),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: Wrap(
                          spacing: 5,
                          runSpacing: 3,
                          children: [
                            ...tags.map((tag) => FilterChip(
                                label: Text(tag),
                                onSelected: (bool selected) {},
                                side: BorderSide(color: Colors.black, width: 1),
                                backgroundColor: Colors.transparent,
                                labelStyle: TextStyle(color: Colors.black)))
                          ],
                        )),

                        /* TextButton.icon(onPressed:
                      (){}, icon:  Icon(
                          Icons.edit_rounded
                      ), label: Text(
                          "Editar"
                          
                      )),*/
                      ]),
                ),
              ],
            ),
          ),

          /*Wrap(
          children: List<Widget>.generate(
            options.length,
                (int idx) {
              return ChoiceChip(
                  label: Text(options[idx]),
                  selected: _value == idx,
                  onSelected: (bool selected) {
                    setState(() {
                      _value = selected ? idx : null;
                    });
                  });
            },
          ).toList(),
        );*/
        ]));
  }
}

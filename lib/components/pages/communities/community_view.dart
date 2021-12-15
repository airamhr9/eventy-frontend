import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/chat/chat_community.dart';
import 'package:eventy_front/components/pages/communities/add_new_post.dart';
import 'package:eventy_front/components/pages/communities/post.dart';
import 'package:eventy_front/components/pages/my_events/add_event.dart';
import 'package:eventy_front/components/widgets/comment.dart';
import 'package:eventy_front/components/widgets/filled_button.dart';
import 'package:eventy_front/components/widgets/moving_title.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/chat_service.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/muro_service.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'communityEvents.dart';

class CommunityView extends StatefulWidget {
  final Community community;
  const CommunityView(this.community) : super();

  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<CommunityView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> myTabs = [
    Tab(text: 'Muro'),
    Tab(text: 'Hablemos'),
  ];
  String userId = "";
  List<PostObject> muro = [];
  bool muroLoading = true;
  bool chatLoading = true;

  List<Message> comments = [];
  bool hasComments = false;
  late User user;
  bool hasUser = false;

  bool wait = true;

  late Community community;

  @override
  void initState() {
    community = widget.community;

    _tabController = TabController(length: 2, vsync: this);
    MySharedPreferences.instance.getStringValue("userId").then((value) {
      setState(() {
        userId = value;
      });
      UserService().getUser(userId).then((value) {
        setState(() {
          user = value;
          hasUser = true;
        });
      });
    });

    _fetchMuro();
    _fetchChat();
    _fetchCommunity();
    super.initState();
  }

  void _fetchMuro() {
    muroLoading = true;
    MuroService()
        .getCommunityMuro(widget.community.id)
        .then((value) => setState(() {
              muro = value;
              muroLoading = false;
              print("value loaded with ${value.length} posts");
              print("muro loaded with ${muro.length} posts");
            }));
  }

  void _fetchCommunity() {
    CommunityService()
        .getCommunity(widget.community.id)
        .then((value) => setState(() {
              community = value;
            }));
  }

  _fetchChat() {
    ChatService().getCommunityMessages(widget.community.id).then((value) {
      setState(() {
        comments.addAll(value);
        comments = comments.reversed.toList();
        hasComments = true;
        wait = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("OnPoint"),
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFFAFAFA),
          foregroundColor: Colors.black,
        ),
        body: (!wait)
            ? Container(
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.blue, width: 5),
                )),
                child: NestedScrollView(
                    headerSliverBuilder: (context, boolean) {
                      return [
                        SliverToBoxAdapter(child: buildTop()),
                      ];
                    },
                    body: Column(children: [
                      TabBar(
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
                      ),
                      Expanded(
                        child:
                            TabBarView(controller: _tabController, children: [
                          buildTabMuro(),
                          buildTabChat(),
                        ]),
                      ),
                    ])),
              )
            : (Center(child: CircularProgressIndicator())));
  }

  Widget buildTop() {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 80,
          child: MovingTitle(community.name),
        ),
        (!isMember) ? buildAddButton() : SizedBox(),
        SizedBox(
          height: 20,
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            viewportFraction: 1,
            enableInfiniteScroll: false,
          ),
          items: community.images.map((i) {
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
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w100, color: Colors.black54),
              ),
              SizedBox(
                height: 10,
              ),
              Text(community.description)
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          thickness: 1,
          color: Colors.black,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 5,
                runSpacing: 3,
                children: [
                  ...community.tags.map((tag) => FilterChip(
                      label: Text(tag),
                      onSelected: (bool selected) {},
                      side: BorderSide(color: Colors.black, width: 1),
                      backgroundColor: Colors.transparent,
                      labelStyle: TextStyle(color: Colors.black)))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${community.members.length} miembros",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 5,
                runSpacing: 3,
                children: [
                  ...community.members.map((member) => CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue,
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              buildEvent(),
            ],
          ),
        ),
      ],
    );
  }

  buildAddButton() {
    if (community.members.contains(userId) || community.creator == userId) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Divider(
            thickness: 1,
            height: 0,
            color: Colors.black,
          ),
          FilledButton(
              text: "Unirse",
              onPressed: () {
                CommunityService()
                    .sendNewMember(community.id.toString(), userId);
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
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  isMember = true;
                                });
                              })
                        ],
                      );
                    });
              })
        ],
      );
    }
  }

  buildTextMembers() {
    if (community.members.length > 1) {
      return Text("  " + community.members.length.toString() + " miembros",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
    } else {
      return Text("  " + community.members.length.toString() + " miembro",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
    }
  }

  Widget buildTabDetalles() {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Text(community.description),
      ),
    );
  }

  Widget buildTabChat() {
    return Column(
      children: [
        TextButton.icon(
            style: TextButton.styleFrom(elevation: 0, primary: Colors.black),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController commentController =
                        TextEditingController();
                    return AlertDialog(
                      title: Text("Comentar"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.black54),
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
                                    userId,
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
                                ChatService().sendMessageCommunity(
                                    messageToSend, widget.community.id);
                              }
                            },
                            child: Text(
                              "Comentar",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                      content: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: commentController,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 25, left: 15),
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1)),
                              filled: true,
                              hintText: "Comentario"),
                        ),
                      ),
                    );
                  });
            },
            icon: Icon(Icons.create_outlined),
            label: Text("Comentar")),
        Container(
          child: buildComments(),
        )
      ],
    );
  }

  Widget buildComments() {
    return (!hasComments)
        ? (Center(child: CircularProgressIndicator()))
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
              );
  }

  Widget buildTabMuro() {
    return Column(
      children: [
        TextButton.icon(
            style: TextButton.styleFrom(elevation: 0, primary: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNewPost(community.id, _fetchMuro)),
              );
            },
            icon: Icon(Icons.create_outlined),
            label: Text("Nueva publicación")),
        (!muroLoading)
            ? (muro.length > 0)
                ? Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Post(muro[index])
                            ],
                          );
                        } else
                          return Post(muro[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                      itemCount: muro.length,
                    ),
                  )
                : Center(
                    child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text("No hay posts en el muro"),
                    ],
                  ))
            : (Center(child: CircularProgressIndicator()))
      ],
    );
  }

  bool isMember = false;
  Future<bool> checkUser() async {
    userId = await MySharedPreferences.instance.getStringValue("userId");
    for (String userIdInCommunity in community.members) {
      if (userId == userIdInCommunity) {
        return isMember = true;
      }
    }
    return isMember;
  }

  buildEvent() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Eventos",
              style: TextStyle(
                  fontFamily: 'Tiny', fontSize: 30, color: Colors.black),
            ),
            buildButtonCreateEvent(),
          ],
        ),
      ),
      SizedBox(height: 200, child: CommunityEvents(community)),
    ]);
  }

  buildButtonCreateEvent() {
    if (community.creator == userId) {
      return TextButton(
          child: Text(
            "Crear evento",
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEvent(community.id)),
            );
          });
    } else {
      return SizedBox(height: 0);
    }
  }
}

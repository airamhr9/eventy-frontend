import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/chat/chat_community.dart';
import 'package:eventy_front/components/pages/communities/post.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

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
    Tab(text: 'Eventos'),
    Tab(text: 'Detalles'),
  ];
  String userId = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatCommunity(widget.community)));
              },
              icon: Icon(Icons.chat))
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
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  child: NestedScrollView(
                      headerSliverBuilder: (context, boolean) {
                        return [
                          SliverToBoxAdapter(child: buildTop()),
                          SliverToBoxAdapter(
                            child: TabBar(
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
                          ),
                        ];
                      },
                      body: Container(
                          child: TabBarView(
                              controller: _tabController,
                              children: [
                            buildTabMuro(),
                            buildTabEventos(),
                            buildTabDetalles()
                          ]))),
                ),
              ))),
      floatingActionButton: buildAddToCommunityButton(),
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
          items: widget.community.images.map((i) {
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
          child: Row(
            children: [
              Spacer(),
              Icon(Icons.people, size: 24),
              buildTextMembers(),
              Spacer()
            ],
          ),
        ),
      ],
    );
  }

  buildTextMembers() {
    if (widget.community.members.length > 1) {
      return Text(
          "  " + widget.community.members.length.toString() + " miembros",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
    } else {
      return Text(
          "  " + widget.community.members.length.toString() + " miembro",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
    }
  }

  Widget buildTabDetalles() {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Text(widget.community.description),
      ),
    );
  }

  Widget buildTabEventos() {
    return Center(child: Text("Eventos"));
  }

  Widget buildTabMuro() {
    List<PostObject> posts = [
      PostObject(
          "id",
          "Título del post",
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          "2016-10-20T00:00:00.000",
          "Juan Antonio",
          123, []),
      PostObject(
          "id",
          "Título del post pero ahora mucho más largo vamos a ver qué tal aunque debe ser más largo aparentemente joder",
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever",
          "2012-10-20T00:00:00.000",
          "Juan Antonio",
          123, [
        "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fevents%2Ferasmus.png?alt=media&token=8a744c36-4656-4d38-aee7-306e980b3d79"
      ])
    ];

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Post(posts[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemCount: posts.length,
    );
  }

  bool isMember = false;
  Future<bool> checkUser() async {
    userId = await MySharedPreferences.instance.getStringValue("userId");
    for (String userIdInCommunity in widget.community.members) {
      if (userId == userIdInCommunity) {
        return isMember = true;
      }
    }
    return isMember;
  }

  buildAddToCommunityButton() {
    checkUser();
    if (isMember == false) {
      return FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Unirse"),
        onPressed: () {
          CommunityService()
              .sendNewMember(widget.community.id.toString(), userId);
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
        },
      );
    } else {}
  }
}

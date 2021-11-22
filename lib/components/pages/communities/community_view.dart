import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/chat/chat_community.dart';
import 'package:eventy_front/components/pages/communities/add_new_post.dart';
import 'package:eventy_front/components/pages/communities/post.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/muro_service.dart';
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
  List<PostObject> muro = [];
  bool muroLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _fetchMuro();
  }

  void _fetchMuro() {
    MuroService()
        .getCommunityMuro(widget.community.id)
        .then((value) => setState(() {
              muro = value;
              muroLoading = false;
              print("value loaded with ${value.length} posts");
              print("muro loaded with ${muro.length} posts");
            }));
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
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
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
        SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                // double.infinity is the width and 30 is the height
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddNewPost(widget.community.id)),
              );
            },
            icon: Icon(Icons.add_circle_rounded),
            label: Text("Nueva publicación")),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  buildTextMembers() {
    if (widget.community.members.length > 1) {
      return Text(
          "  " + widget.community.members.length.toString() + " miembros",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
    } else {
      return Text(
          "  " + widget.community.members.length.toString() + " miembro",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18));
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
    return (!muroLoading)
        ? (muro.length > 0)
            ? ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Post(muro[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemCount: muro.length,
              )
            : Center(
                child: Text("No hay posts en el muro"),
              )
        : (Center(child: CircularProgressIndicator()));
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
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            isMember = true;
                          });
                        })
                  ],
                );
              });
        },
      );
    } else {}
  }
}

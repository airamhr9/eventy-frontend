import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/chat/chat.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    Tab(text: 'Eventos'),
    Tab(text: 'Detalles'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                        builder: (context) => Chat(widget.community)));
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
              Text(
                  "  " +
                      widget.community.members.length.toString() +
                      " miembros",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              Spacer()
            ],
          ),
        ),
      ],
    );
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

  addMemberToCommunity() async {
    String userId = await MySharedPreferences.instance.getStringValue('userId');
    CommunityService().sendNewMember(widget.community.id.toString(), userId);
  }

  bool isMember = false;
  Future<bool> checkUser() async {
    String userId = await MySharedPreferences.instance.getStringValue("userId");
    for (String userIdInCommunity in widget.community.members) {
      if (userId == userIdInCommunity) {
        return isMember = true;
      }
    }
    return isMember;
  }

  buildAddToCommunityButton() {
    if (isMember == true) {
      return FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Unirse"),
        onPressed: () {
          addMemberToCommunity();
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

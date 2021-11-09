import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Friends extends StatefulWidget {
  final String userId;
  const Friends(this.userId) : super();

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with TickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  late TabController _tabController;
  List<User> friends = [];
  List<User> requests = [];
  bool hasFriendsResponse = false;
  final List<Widget> myTabs = [
    Tab(text: 'Amigos'),
    Tab(text: 'Solicitudes'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    _fetchFriends();
  }

  Future _fetchFriends() async {
    final userService = UserService();

    final results = await userService.getFriends(widget.userId);

    setState(() {
      friends = results[0];
      requests = results[1];
      hasFriendsResponse = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Mis amigos"),
        ),
        backgroundColor: Colors.blue[500],
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: NestedScrollView(
              headerSliverBuilder: (context, boolean) {
                return [
                  SliverToBoxAdapter(
                      child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          filled: true,
                          hintText: "Buscar usuarios",
                        ),
                        onChanged: (text) {
                          setState(() {
                            searchText = _searchController.text;
                          });
                        },
                      ),
                      TabBar(
                        indicator: MaterialIndicator(
                          color: Theme.of(context).primaryColor,
                          horizontalPadding: 50,
                          topLeftRadius: 20,
                          topRightRadius: 20,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        labelColor: Colors.black87,
                        controller: _tabController,
                        isScrollable: false,
                        tabs: myTabs,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )),
                ];
              },
              body: Container(
                  child: TabBarView(controller: _tabController, children: [
                buildTabFriends(),
                buildTabRequests(),
              ]))),
        ));
  }

  Widget buildTabFriends() {
    return (!hasFriendsResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (friends.length <= 0)
            ? Center(
                child: Text("No tienes amigos"),
              )
            : Column(
                children: [
                  ...friends.map((participant) => ListTile(
                        leading: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    participant.profilePicture,
                                  )),
                            )),
                        title: Text(participant.userName),
                      ))
                ],
              );
  }

  Widget buildTabRequests() {
    return (!hasFriendsResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (friends.length <= 0)
            ? Center(
                child: Text("No tienes peticiones de amistad"),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ...requests.map((requester) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                requester.profilePicture,
                                              )),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(requester.userName),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => showRequestDialog(
                                          widget.userId, requester, "reject"),
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => showRequestDialog(
                                          widget.userId, requester, "accept"),
                                      icon: Icon(
                                        Icons.check_rounded,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ))
                  ],
                ),
              );
  }

  void showRequestDialog(String userId, User requester, String response) {
    late String dialogMessage;
    late String dialogAction;
    late Color dialogActionColor;
    late String snackbarMessage;
    if (response == "accept") {
      dialogMessage = "¿Aceptar a ${requester.userName}?";
      dialogAction = "Aceptar";
      dialogActionColor = Colors.green;
      snackbarMessage = "${requester.userName} aceptado";
    } else {
      dialogMessage = "¿Rechazar a ${requester.userName}?";
      dialogAction = "Rechazar";
      dialogActionColor = Colors.red;
      snackbarMessage = "${requester.userName} rechazado";
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              dialogMessage,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black87),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                  )),
              TextButton(
                  onPressed: () {
                    handleFriendRequest(userId, requester, response);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(snackbarMessage),
                      backgroundColor: dialogActionColor,
                    ));
                  },
                  child: Text(
                    dialogAction,
                    style: TextStyle(color: dialogActionColor),
                  ))
            ],
          );
        });
  }

  void handleFriendRequest(String userId, User requester, String response) {
    UserService().handleFriendRequest(userId, requester.userName, response);
    setState(() {
      requests.remove(requester);
    });
    if (response == "accept") {
      setState(() {
        friends.add(requester);
      });
    }
  }
}

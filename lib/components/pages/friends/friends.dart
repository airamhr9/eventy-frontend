import 'package:eventy_front/components/pages/friends/groups.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/group_service.dart';
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
  bool searching = false;
  bool hasResults = false;
  List<User> fromFriends = [];
  List<User> fromDatabase = [];

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
        resizeToAvoidBottomInset: false,
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
                      onSubmitted: (value) => searchFriends(value),
                      decoration: InputDecoration(
                        suffixIcon: (_searchController.text.length > 0)
                            ? IconButton(
                                icon: Icon(Icons.close_rounded),
                                onPressed: () => setState(() {
                                  _searchController.text = "";
                                  searching = false;
                                }),
                              )
                            : null,
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
                        if (text == "") {
                          setState(() {
                            searching = false;
                          });
                        }
                      },
                    ),
                    (!searching)
                        ? TabBar(
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
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )),
              ];
            },
            body: (!searching)
                ? Container(
                    child: TabBarView(controller: _tabController, children: [
                    buildTabFriends(),
                    buildTabRequests(),
                  ]))
                : (!hasResults)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          (fromFriends.length > 0)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          "Tus amigos",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      ...fromFriends.map((user) => ListTile(
                                            leading: Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        user.profilePicture,
                                                      )),
                                                )),
                                            title: Text(user.userName),
                                          ))
                                    ])
                              : SizedBox(),
                          SizedBox(
                            height: 10,
                          ),
                          (fromDatabase.length > 0)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          "Todos",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      ...fromDatabase.map((user) => ListTile(
                                            onTap: () =>
                                                showRequestSheet(user, false),
                                            leading: Container(
                                                width: 45,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                        user.profilePicture,
                                                      )),
                                                )),
                                            title: Text(user.userName),
                                          ))
                                    ])
                              : SizedBox()
                        ],
                      ),
          ),
        ));
  }

  void showRequestSheet(User user, bool groupRequest) {
    late String requestMessage;
    late String scaffoldMessage;
    if (groupRequest) {
      requestMessage = "Enviar solicitud de grupo";
      scaffoldMessage = "Solicitud de amistad enviada";
    } else {
      requestMessage = "Crear nuevo grupo";
      scaffoldMessage = "Creado nuevo grupo e invitación enviada";
    }

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
                height: 250,
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      user.profilePicture,
                                    )),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            user.userName,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            user.bio,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                        ]),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                          minimumSize: Size(double.infinity, 40),
                        ),
                        onPressed: () {
                          if (groupRequest) {
                            GroupService().createGroup(
                                widget.userId, List.filled(1, user.id));
                          } else {
                            UserService().handleFriendRequest(
                                widget.userId, user.userName, "REQUEST");
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(requestMessage),
                            backgroundColor: Colors.green,
                          ));
                          if (groupRequest) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Groups(widget.userId)));
                          }
                        },
                        icon: Icon(Icons.add_rounded),
                        label: Text(scaffoldMessage)),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ));
          });
        });
  }

  void searchFriends(String text) async {
    if (text.trim() == "") {
      return;
    }
    setState(() {
      searching = true;
      hasResults = false;
    });

    final fromFriendsAux =
        friends.where((friend) => friend.userName.contains(text)).toList();
    List<User> fromDatabaseAux = await UserService().search(text);
    final setFriends = Set.from(fromFriendsAux);
    final setDatabase = Set.from(fromDatabaseAux);
    List<User> common = List.from(setFriends.difference(setDatabase));
    common.forEach((elem) => {
          fromDatabaseAux.removeWhere((user) => user.userName == elem.userName)
        });
    fromDatabaseAux.removeWhere((user) => user.id == widget.userId);

    setState(() {
      fromFriends = fromFriendsAux;
      fromDatabase = fromDatabaseAux;
      hasResults = true;
    });
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
                  ...friends.map((friend) => ListTile(
                        onTap: () => showRequestSheet(friend, true),
                        leading: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    friend.profilePicture,
                                  )),
                            )),
                        title: Text(friend.userName),
                      ))
                ],
              );
  }

  Widget buildTabRequests() {
    return (!hasFriendsResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (requests.length <= 0)
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

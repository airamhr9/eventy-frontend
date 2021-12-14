import 'package:eventy_front/components/pages/friends/group_detail.dart';
import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/group_request.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/objects/user_group.dart';
import 'package:eventy_front/services/group_service.dart';
import 'package:eventy_front/services/muro_service.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class Groups extends StatefulWidget {
  final String userId;
  const Groups(this.userId, {Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with TickerProviderStateMixin {
  final List<Widget> myTabs = [
    Tab(text: 'Grupos'),
    Tab(text: 'Solicitudes'),
  ];
  late TabController _tabController;
  List<Group> groups = [];
  List<GroupRequest> requests = [];
  List<User> friends = [];
  bool hasGroupsResponse = false;
  bool hasRequestsResponse = false;
  bool hasFriendsResponse = false;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();

    _fetchGroups();
  }

  Future _fetchGroups() async {
    final groupService = GroupService();

    final results = await Future.wait([
      groupService.getGroups(widget.userId),
      groupService.getRequests(widget.userId),
    ]);

    setState(() {
      groups = results[0] as List<Group>;
      hasGroupsResponse = true;
    });
    setState(() {
      requests = results[1] as List<GroupRequest>;
      hasRequestsResponse = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Mis grupos"),
          foregroundColor: Colors.black,
          actions: [
            IconButton(onPressed: updateGroups, icon: Icon(Icons.refresh))
          ],
        ),
        backgroundColor: Colors.blue[500],
        body: Container(
            width: double.infinity,
            padding: EdgeInsets.only(right: 10, left: 10, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black, width: 1)),
            ),
            child: NestedScrollView(
                headerSliverBuilder: (context, boolean) {
                  return [
                    SliverAppBar(
                      primary: false,
                      toolbarHeight: 0,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      pinned: true,
                      bottom: TabBar(
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
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    )
                  ];
                },
                body: Container(
                    child: TabBarView(controller: _tabController, children: [
                  buildTabGroups(),
                  buildTabRequests(),
                ])))));
  }

  Widget buildTabGroups() {
    return (!hasGroupsResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (groups.length <= 0)
            ? Center(
                child: Text("No tienes grupos"),
              )
            : Column(
                children: [
                  ...groups.map((group) => ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GroupDetail(group, widget.userId)));
                        },
                        leading: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(buildGroupImage(group))),
                            )),
                        title: Text(buildGroupTitle(group)),
                      ))
                ],
              );
  }

  String buildGroupTitle(Group group) {
    String creatorName = group.users
        .firstWhere((element) => element.id == group.creator)
        .username;
    return "Grupo de $creatorName y ${group.users.length - 1} más";
  }

  String buildGroupImage(Group group) {
    return group.users
        .firstWhere((element) => element.id == group.creator)
        .imageUrl;
  }

  Widget buildTabRequests() {
    return (!hasRequestsResponse)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (requests.length <= 0)
            ? Center(
                child: Text("No tienes invitaciones de grupo"),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ...requests.map((request) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                request.user.profilePicture,
                                              )),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(request.user.userName),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          showRequestDialog(request, "reject"),
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          showRequestDialog(request, "accept"),
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

  void updateGroups() async {
    setState(() {
      hasGroupsResponse = false;
    });
    GroupService().getGroups(widget.userId).then((value) => setState(() {
          groups = value;
          hasGroupsResponse = true;
        }));
  }

  void showRequestDialog(GroupRequest request, String response) {
    late String dialogMessage;
    late String dialogAction;
    late Color dialogActionColor;
    late String snackbarMessage;
    if (response == "accept") {
      dialogMessage = "Unirse al grupo de ${request.user.userName}?";
      dialogAction = "Unirse";
      dialogActionColor = Colors.green;
      snackbarMessage = "Te has unido al grupo de ${request.user.userName}";
    } else {
      dialogMessage =
          "¿Rechazar invitación al grupo de ${request.user.userName}?";
      dialogAction = "Rechazar";
      dialogActionColor = Colors.red;
      snackbarMessage = "Has rechazado el grupo de ${request.user.userName}";
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
                    handleGroupRequest(request, response);
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

  void handleGroupRequest(GroupRequest request, String response) async {
    GroupService groupService = GroupService();
    setState(() {
      requests.remove(request);
    });
    if (response == "accept") {
      print("request accepted");
      Map<String, dynamic> filters = {};
      filters["userId"] = widget.userId;
      filters["validPreferences"] = false;
      groupService.updateUser(request.groupId, filters, userId: widget.userId);
      updateGroups();
    } else {
      groupService.rejectGroupRequest(request.groupId, widget.userId);
    }
  }
}

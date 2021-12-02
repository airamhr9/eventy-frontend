import 'package:eventy_front/components/pages/communities/community_view.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:flutter/material.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities() : super();

  @override
  _MyCommunitiesState createState() => _MyCommunitiesState();
}

class _MyCommunitiesState extends State<MyCommunities> {
  List<Community> myCommunitiesList = [];
  String userId = "";

  @override
  void initState() {
    super.initState();
    CommunityService().get().then((value) => setState(() {
          myCommunitiesList = value;
          print(myCommunitiesList.length);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return myCommunitiesList.length > 0
        ? ListView.separated(
            itemCount: myCommunitiesList.length,
            itemBuilder: (context, position) {
              return Container(
                  child: ListTile(
                title: Text(
                  myCommunitiesList[position].name,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                subtitle: buildTextMembers(
                    myCommunitiesList[position].members.length),
                leading: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            myCommunitiesList[position].logo,
                          )),
                    )),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommunityView(myCommunitiesList[position])));
                },
              ));
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.black,
                thickness: 1,
              );
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  buildTextMembers(int numMembers) {
    if (numMembers > 1) {
      return Text(
        numMembers.toString() + " miembros",
      );
    } else {
      return Text(
        numMembers.toString() + " miembro",
      );
    }
  }

  getCommunities() async {
    await CommunityService().get().then((value) => setState(() {
          myCommunitiesList = value;
          print(myCommunitiesList.length);
        }));
  }
}

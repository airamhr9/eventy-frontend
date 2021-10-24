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
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black87),
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.people, size: 18),
                    Text("  " +
                        myCommunitiesList[position].members.length.toString() +
                        " miembros")
                  ],
                ),
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              );
            },
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  getCommunities() async {
    await CommunityService().get().then((value) => setState(() {
          myCommunitiesList = value;
          print(myCommunitiesList.length);
        }));
  }
}

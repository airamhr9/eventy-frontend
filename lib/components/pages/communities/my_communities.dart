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

  @override
  void initState() {
    super.initState();
    CommunityService().get().then((value) => setState(() {
          print("Here");
          myCommunitiesList = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: myCommunitiesList.length,
      itemBuilder: (context, position) {
        return ListTile(
          title: Text(myCommunitiesList[position].name),
          subtitle: Row(
            children: [
              Icon(Icons.person),
              Text(myCommunitiesList[position].members.length.toString() +
                  " miembros")
            ],
          ),
          leading: Icon(Icons.person)
          /*CircleAvatar(backgroundImage: 
              AssetImage(myCommunitiesList[position].logo)
            )*/
          ,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CommunityView(myCommunitiesList[position])));
          },
        );
      },
    ));
  }
}

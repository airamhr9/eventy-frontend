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
    return ListView.separated(
      itemCount: myCommunitiesList.length,
      itemBuilder: (context, position) {
        return Container(
            child: ListTile(
          title: Text(myCommunitiesList[position].name),
          subtitle: Row(
            children: [
              Icon(Icons.people, size: 18),
              Text("  " +
                  myCommunitiesList[position].members.length.toString() +
                  " miembros")
            ],
          ),
          leading:
            /*CircleAvatar(backgroundImage: 
              AssetImage(myCommunitiesList[position].logo)
            ),*/
            CircleAvatar(
            backgroundColor: Colors.purpleAccent,
            ),
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
    );
  }
}

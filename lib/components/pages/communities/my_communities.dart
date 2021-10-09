import 'package:eventy_front/objects/community.dart';
import 'package:flutter/material.dart';

class MyCommunities extends StatefulWidget {
  const MyCommunities() : super();

  @override
  _MyCommunitiesState createState() => _MyCommunitiesState();
}

List<Community> MyCommunitiesList = [];

class _MyCommunitiesState extends State<MyCommunities> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          /*ListView.builder(
            itemCount: MyCommunitiesList.length,
            itemBuilder: (context, position){
              // Devolver la comunidad 
            },
          ),*/
        ],
      ),
    ));
  }
}

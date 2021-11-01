import 'package:eventy_front/components/pages/chat/chat_community.dart';
import 'package:eventy_front/components/pages/chat/chat_event.dart';
import 'package:eventy_front/components/pages/communities/community_view.dart';
import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class CommunitySearchResult extends StatefulWidget {
  final Community community;
  const CommunitySearchResult(this.community) : super();

  @override
  _CommunitySearchResultState createState() => _CommunitySearchResultState();
}

class _CommunitySearchResultState extends State<CommunitySearchResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.community.images.first,
                    fit: BoxFit.cover,
                  ),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${widget.community.members.length} miembros",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.community.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Spacer(),
                TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommunityView(widget.community)));
                    },
                    label: Text("Saber más"),
                    icon: Icon(Icons.add_rounded)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

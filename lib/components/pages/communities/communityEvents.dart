import 'package:eventy_front/components/pages/my_events/related_event_card.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CommunityEvents extends StatefulWidget {
  final Community community;
  const CommunityEvents(this.community) : super();

  @override
  _CommunityEventsState createState() => _CommunityEventsState();
}

class _CommunityEventsState extends State<CommunityEvents> {
  List<Event> relatedEvents = [];
  bool hasEvents = false;

  @override
  initState() {
    _fetchEvents();
    super.initState();
    print("id de comunidad " + widget.community.id.toString());
  }

  _fetchEvents() async {
    CommunityService().getCommunityEvents(widget.community.id)
        .then((value) => setState(() {

              relatedEvents = value;
              print("Events loaded: " + relatedEvents.length.toString());
              print(relatedEvents.toString());
              hasEvents = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
        ),

        (hasEvents)
            ? (relatedEvents.length > 0)
                ? Expanded(
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            RelatedEvent(relatedEvents[index]),
                        separatorBuilder: (context, int) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 85.0, left: 10, right: 10),
                              child: VerticalDivider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                        itemCount: relatedEvents.length),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text("No hay eventos en esta comunidad")
                    ],
                  )
            : CircularProgressIndicator()
      ]),
    );
  }
}

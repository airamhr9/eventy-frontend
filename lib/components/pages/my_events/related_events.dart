import 'package:eventy_front/components/pages/my_events/related_event_card.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RelatedEvents extends StatefulWidget {
  final Event event;
  const RelatedEvents(this.event) : super();

  @override
  _RelatedEventsState createState() => _RelatedEventsState();
}

class _RelatedEventsState extends State<RelatedEvents> {
  List<Event> relatedEvents = [];
  bool hasEvents = false;

  @override
  initState() {
    _fetchEvents();
    super.initState();
  }

  _fetchEvents() async {
    EventService()
        .getRelatedEvents(widget.event.id, widget.event.tags,
            widget.event.latitude, widget.event.longitude)
        .then((value) => setState(() {
              relatedEvents = value;
              hasEvents = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Eventos relacionados",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 20,
        ),
        (hasEvents)
            ? (relatedEvents.length > 0)
                ? Expanded(
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (contex, index) =>
                            RelatedEvent(relatedEvents[index]),
                        separatorBuilder: (context, int) => Transform.rotate(
                            angle: .2,
                            child: VerticalDivider(
                              thickness: 1,
                              color: Colors.black,
                            )),
                        itemCount: relatedEvents.length),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text("No hay eventos relacionados")
                    ],
                  )
            : CircularProgressIndicator()
      ]),
    );
  }
}

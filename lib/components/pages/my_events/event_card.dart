import 'package:eventy_front/components/pages/my_events/event_view.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/survey.dart';
import 'package:eventy_front/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final Event event;
  const EventCard(this.event) : super();

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late String date;
  bool showDate = true;

  @override
  void initState() {
    super.initState();
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
    EventService().getSurveys(widget.event.id.toString()).then((value) {
      for (Survey s in value) {
        if (s.question == "¿Qué fecha prefieres?") {
          setState(() {
            showDate = false;
            print(showDate);
          });
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EventView(widget.event)));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.blue),
              width: 10,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 10,
                          child: Text(
                            widget.event.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black87),
                          ),
                        ),
                        buildTextDate(),
                      ],
                    ),
                    Text(
                      widget.event.address,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextDate() {
    if (showDate == true) {
      return Text(
        this.date,
        style: TextStyle(fontSize: 15, color: Colors.black),
      );
    } else {
      return SizedBox(
        height: 0,
      );
    }
  }
}

import 'package:eventy_front/components/pages/chat/chat_event.dart';
import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final Event event;
  const EventCard(this.event) : super();

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late String date;

  @override
  void initState() {
    super.initState();
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                    widget.event.images.first,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        this.date,
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatEvent(widget.event)));
                        },
                        icon: Icon(
                          Icons.chat_rounded,
                          size: 18,
                        ),
                        label: Text(
                          "Chat",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.event.name,
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
                TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventLocation(LatLng(
                                  widget.event.latitude,
                                  widget.event.longitude))));
                    },
                    label: Text("Ver en mapa"),
                    icon: Icon(Icons.place_rounded)),
                Spacer(),
                TextButton.icon(
                    onPressed: () {},
                    label: Text("Detalles"),
                    icon: Icon(Icons.add_rounded)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

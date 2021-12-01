import 'package:eventy_front/components/pages/chat/chat_event.dart';
import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/components/pages/my_events/event_view.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class SearchResult extends StatefulWidget {
  final Event event;
  const SearchResult(this.event) : super();

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late String date;
  late String userId;

  @override
  void initState() {
    super.initState();
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventView(widget.event)));
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                widget.event.name,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: Colors.black87),
              ),
            ),
            Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  child: Image.network(
                    widget.event.images.first,
                    fit: BoxFit.fitWidth,
                  ),
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                        "● ${widget.event.address}",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        this.date,
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

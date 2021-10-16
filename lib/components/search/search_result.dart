import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchResult extends StatefulWidget {
  final Event event;
  const SearchResult(this.event) : super();

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
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
                  Text(
                    widget.event.startDate,
                    style: TextStyle(fontSize: 15, color: Colors.black54),
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

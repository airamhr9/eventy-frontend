import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/components/pages/home/participants_list.dart';
import 'package:flutter/material.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecommendedEvent extends StatefulWidget {
  final Event event;
  const RecommendedEvent(this.event) : super();

  @override
  RecommendedEventState createState() => RecommendedEventState();
}

class RecommendedEventState extends State<RecommendedEvent> {
  late String plazasLabel = "Ver a los asistentes";
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
                height: 240.0,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: widget.event.images.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          i,
                          fit: BoxFit.cover,
                        ),
                      ));
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.event.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 5.0,
                  height: 5.0,
                  margin: EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.7 : 0.3)),
                ),
              );
            }).toList(),
          ),
          Container(
            color: Color(0xFFFAFAFA),
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  widget.event.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 26,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.event.startDate,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.event.summary,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: widget.event.tags
                      .map((e) => Chip(
                            label: Text(e),
                            backgroundColor: Colors.grey.withOpacity(.1),
                          ))
                      .toList(),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Participants(widget.event)));
                  },
                  icon: Icon(
                    Icons.people_rounded,
                    size: 28,
                  ),
                  label: Text(
                    (widget.event.maxParticipants == -1)
                        ? "Consultar asistentes"
                        : "Quedan ${widget.event.maxParticipants - widget.event.participants.length} plazas",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "VALENCIA, ESPAÑA",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    Spacer(),
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
                        icon: Icon(Icons.place_rounded))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

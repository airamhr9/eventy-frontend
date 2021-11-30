import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/components/pages/chat/chat_event.dart';
import 'package:eventy_front/components/pages/home/event_location.dart';
import 'package:eventy_front/components/pages/home/participants_list.dart';
import 'package:eventy_front/components/pages/my_events/event_view.dart';
import 'package:eventy_front/components/widgets/moving_title.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

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
  late String date;

  @override
  void initState() {
    super.initState();
    date = DateFormat("dd/MM/yyyy HH:mm")
        .format(DateTime.parse(widget.event.startDate));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          minHeight: 20,
          value:
              widget.event.participants.length / widget.event.maxParticipants,
        ),
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
              height: 300.0,
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
                    child: ClipRRect(
                      child: Image.network(
                        i,
                        fit: BoxFit.cover,
                      ),
                    ));
              },
            );
          }).toList(),
        ),
        Divider(
          thickness: 10,
          height: 0,
          color: Colors.black,
        ),
        /*  Row(
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
        ), */
        Container(
          color: Color(0xFFFAFAFA),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: Text(
                              widget.event.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                            )),
                        Text(
                          date.substring(0, 10),
                          style: TextStyle(
                              fontFamily: 'Tiny',
                              fontSize: 20,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Text(
                      "● Cauce del Río, Valencia",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventView(widget.event)));
                      },
                      child: Text(
                        "Saber más",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
          child: Icon(Icons.arrow_downward),
        )
      ],
    );
  }
}

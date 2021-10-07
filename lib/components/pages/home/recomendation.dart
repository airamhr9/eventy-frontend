import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:eventy_front/objects/event.dart';

class RecommendedEvent extends StatefulWidget {
  final Event event;
  const RecommendedEvent(this.event) : super();

  @override
  RecommendedEventState createState() => RecommendedEventState();
}

class RecommendedEventState extends State<RecommendedEvent> {
  late String plazasLabel = "Ver a los asistentes";
  List<String> placeholderImages = [
    "https://media-exp1.licdn.com/dms/image/C561BAQE-51J-8KkMZg/company-background_10000/0/1548357920228?e=2159024400&v=beta&t=D9EoYj6SBCp9zbnp8ZZdHpF27Kl29zabOtAvJw3qz4w",
    "https://partfy.com/user_files/images/12814/96d27938569aab78a9b1f8c3f5f4b045_live-event-streaming.jpg",
    "https://www1.chester.ac.uk/sites/default/files/styles/hero_mobile/public/Music-Production-and-Promotion_0.jpg?itok=AMRG5XBn"
  ];

  @override
  void initState() {
    super.initState();
  }

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
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                viewportFraction: 1,
                enableInfiniteScroll: false,
              ),
              items: placeholderImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            i,
                            fit: BoxFit.fitHeight,
                          ),
                        ));
                  },
                );
              }).toList(),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
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
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton.icon(
                    onPressed: () {},
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
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            //TODO: CAMBIAR ESTO//// PLACEHOLDER PARA EL DISEÑO
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "VALENCIA, ESPAÑA",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "https://risanb.com/code/colorful-google-maps-marker/default-marker.jpg",
                height: 170.0,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }
}

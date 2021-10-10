import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  final Community community;
  const CommunityView(this.community) : super();

  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<CommunityView> {
  List<String> placeholderImages = [
    "https://media-exp1.licdn.com/dms/image/C561BAQE-51J-8KkMZg/company-background_10000/0/1548357920228?e=2159024400&v=beta&t=D9EoYj6SBCp9zbnp8ZZdHpF27Kl29zabOtAvJw3qz4w",
    "https://partfy.com/user_files/images/12814/96d27938569aab78a9b1f8c3f5f4b045_live-event-streaming.jpg",
    "https://www1.chester.ac.uk/sites/default/files/styles/hero_mobile/public/Music-Production-and-Promotion_0.jpg?itok=AMRG5XBn"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        actions: [
          IconButton(
              onPressed: () {
                //Redireccion al chat de la comunidad
              },
              icon: Icon(Icons.chat))
        ],
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
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
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Spacer(),
                  Icon(Icons.people, size: 24),
                  Text(
                      "  " +
                          widget.community.members.length.toString() +
                          " miembros",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  Spacer()
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                          250, 50), // 250 is the width and 100 is the height
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    //Redireccion a lista de eventos de la comunidad
                  },
                  icon: Icon(Icons.calendar_today_rounded),
                  label: Text("Eventos organizados")),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              child: SingleChildScrollView(
                child: Text(widget.community.description),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

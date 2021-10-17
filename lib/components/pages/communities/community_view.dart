import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  final Community community;
  const CommunityView(this.community) : super();

  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<CommunityView> {
  List<String> placeholderImages = [
    "https://pokemongolive.com/img/posts/gobattleleague-season1.jpg",
    "https://lh3.googleusercontent.com/3TSaKxXGo2wT0lu0AyNUBnkk6wkCC2AzOhJyy3JXIPm-AmZ1k9DSAroWeBUyePswCZSs5lVp3mPF7HzUpY9VPlyOV5eddITONINr3WSqLNLm=e365-w600",
    "https://i.blogs.es/2e39a5/anniversaryposter2019/1366_2000.jpeg",
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
            ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                          250, 50), // 250 is the width and 100 is the height
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    if(widget.community.private == false){
                      showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                  "Te has unido con exito",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.black87),
                                ),
                                content: Icon(Icons.check_circle_outline_rounded),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("Vale"),
                                  )
                                ],
                              );
                            });
                    } else {
                      showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                  "Solicitud enviada",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.black87),
                                ),
                                content: Text(
                                    "Si su solicitud es aceptada le llegará una notificación"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("Vale"),
                                  )
                                ],
                              );
                            });
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("Unirse")),
          ],
        ),
      ),
    );
  }
}

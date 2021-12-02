import 'package:eventy_front/components/pages/my_events/memories_card.dart';
import 'package:eventy_front/components/widgets/filled_button.dart';
import 'package:eventy_front/objects/memorie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EventsMemories extends StatefulWidget {
  final String eventId;
  const EventsMemories(this.eventId) : super();

  @override
  _EventsMemoriesState createState() => _EventsMemoriesState();
}

class _EventsMemoriesState extends State<EventsMemories> {
  List<Memorie> memories = [];
  bool hasMemories = false;

  @override
  initState() {
    _fetchEvents();
    super.initState();
  }

  _fetchEvents() async {
    /*EventService()
        .getEventMemories(eventId)
        .then((value) => setState(() {
              memories = value;
              hasMemories = true;
            }));*/
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Recuerdos",
          style:
              TextStyle(fontFamily: 'Tiny', fontSize: 30, color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        (hasMemories)
            ? (memories.length > 0)
                ? Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (contex, index) =>
                            MemoriesCard(memories[index]),
                        itemCount: memories.length),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("No hay recuerdos"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: FilledButton(text: "Añadir", onPressed: () {}),
                      )
                    ],
                  )
            : CircularProgressIndicator()
      ]),
    );
  }
}

import 'package:eventy_front/components/pages/communities/add_communities.dart';
import 'package:eventy_front/components/pages/my_events/add_event.dart';
import 'package:eventy_front/components/widgets/filled_button.dart';
import 'package:flutter/material.dart';

class Create extends StatefulWidget {
  const Create() : super();

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 130,
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Image.asset('assets/images/create.png')),
      SizedBox(
        height: 50,
      ),
      Text(
        "Crea momentos y conexiones",
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(
        height: 20,
      ),
      FilledButton(
        text: "Crear evento",
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddEvent())),
      ),
      SizedBox(
        height: 10,
      ),
      FilledButton(
        text: "Crear comunidad",
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddCommunity())),
      )
    ]);
  }
}

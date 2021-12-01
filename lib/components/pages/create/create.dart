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
    return Center(
      child: Column(children: [
        FilledButton(
          text: "Crear evento",
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddEvent())),
        ),
        FilledButton(
          text: "Crear comunidad",
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCommunity())),
        )
      ]),
    );
  }
}

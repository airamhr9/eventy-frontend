import 'dart:math';

import 'package:eventy_front/objects/event.dart';
import 'package:flutter/material.dart';

class RelatedEvent extends StatelessWidget {
  final Event event;
  const RelatedEvent(this.event) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(event.images.first),
          backgroundColor: Colors.black,
          radius: 60,
        ),
        SizedBox(
          height: 15,
        ),
        Text(event.name),
        Text(
          "● ${event.address}",
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ],
    );
  }
}

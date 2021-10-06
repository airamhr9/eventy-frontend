import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  const Event() : super();

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Event"));
  }
}

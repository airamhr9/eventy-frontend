import 'package:eventy_front/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'components/root.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final primaryBlue = Color.fromARGB(255, 204, 234, 253);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: primaryBlue, accentColor: primaryBlue),
      home: Root(selectedPage: EventsNavigation.NAV_HOME),
    );
  }
}

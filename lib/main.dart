import 'package:eventy_front/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'components/root.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Root(selectedPage: EventsNavigation.NAV_HOME),
    );
  }
}

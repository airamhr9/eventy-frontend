import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title}) : super();
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      body: Center(child: Text("Hello World")),
    );
  }
}

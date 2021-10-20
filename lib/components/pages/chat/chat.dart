import 'package:eventy_front/objects/community.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final Community community;

  const Chat(this.community) : super();

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Chat de " + widget.community.name)),
      backgroundColor: Colors.blue[500],
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            Expanded(
              child: Text("mensajes"),
            ),
            Container(
                color: Colors.blue,
                width: double.infinity,
                height: 70,
                child: Row(
                  children: [],
                ))
          ],
        ),
      ),
    );
  }
}
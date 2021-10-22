import 'package:eventy_front/components/pages/chat/my_message.dart';
import 'package:eventy_front/components/pages/chat/other_message.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Chat extends StatefulWidget {
  final Community community;

  const Chat(this.community) : super();

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _messageController = TextEditingController();
  List<Message> messages = [];
  String userId = "";

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance
        .getStringValue("userId")
        .then((value) => setState(() {
              userId = value;
            }));
    ChatService().getCommunityMessages(widget.community.id).then((value) {
      setState(() {
        messages = value;
      });
    });
  }

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.separated(
                    reverse: true,
                    itemBuilder: (context, index) {
                      return (messages[index].userId == userId)
                          ? MyMessage(messages[index])
                          : OtherMessage(messages[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: messages.length),
/*                 child: ListView(
                  reverse: true,
                  children: [
                    MyMessage(Message(1, "texto coritto de mensaje",
                        DateTime.now().subtract(Duration(days: 1)), "1")),
                    SizedBox(
                      height: 5,
                    ),
                    OtherMessage(Message(1, "texto coritto de mensaje",
                        DateTime.now().subtract(Duration(days: 1)), "1")),
                    SizedBox(
                      height: 5,
                    ),
                    MyMessage(Message(
                        1,
                        "texto más largo  de mensaje puede considerarse un texto larguito en realidad eh ocupa bastante el champion",
                        DateTime.now().subtract(Duration(days: 1)),
                        "2")),
                    SizedBox(
                      height: 5,
                    ),
                    OtherMessage(Message(
                        1,
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                        DateTime.now().subtract(Duration(days: 1)),
                        "3")),
                    SizedBox(
                      height: 5,
                    ),
                    MyMessage(Message(
                        1,
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                        DateTime.now().subtract(Duration(days: 1)),
                        "3")),
                  ],
                ), */
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                color: Colors.blue,
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _messageController,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 30, left: 15),
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            filled: true,
                            hintText: "Enviar mensaje"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send_rounded,
                      ),
                      color: Colors.white,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

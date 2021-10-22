import 'package:eventy_front/components/pages/chat/my_message.dart';
import 'package:eventy_front/components/pages/chat/other_message.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/chat_service.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:great_list_view/great_list_view.dart';

class ChatEvent extends StatefulWidget {
  final Event event;

  const ChatEvent(this.event) : super();

  @override
  _ChatEventState createState() => _ChatEventState();
}

class _ChatEventState extends State<ChatEvent> with TickerProviderStateMixin {
  final key = GlobalKey<AnimatedListState>();
  final _messageController = TextEditingController();
  List<Message> messages = [];
  String userId = "";
  late User user;

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance
        .getStringValue("userId")
        .then((value) => setState(() {
              userId = value;
              UserService().getUser(userId).then((value) {
                user = value;
              });
            }));
    ChatService().getEventMessages(widget.event.id).then((value) {
      setState(() {
        messages.addAll(value);
        messages = messages.reversed.toList();
        for (int i = 0; i < messages.length; i++) {
          key.currentState!.insertItem(i);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Chat de " + widget.event.name)),
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
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                child: AnimatedList(
                  reverse: true,
                  key: key,
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                        position: animation.drive(
                            Tween(begin: Offset(0, 2), end: Offset(0.0, 0.0))),
                        child: Column(children: [
                          (messages[index].userId == userId)
                              ? MyMessage(messages[index])
                              : OtherMessage(messages[index]),
                          SizedBox(
                            height: 5,
                          )
                        ]));
                  },
                ),
/*                 child: ListView.separated(
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
                    itemCount: messages.length), */
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
                                EdgeInsets.only(bottom: 25, left: 15),
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            filled: true,
                            hintText: "Enviar mensaje"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        String messageText = _messageController.text.trim();
                        if (messageText.isNotEmpty) {
                          Message newMessage = Message("", messageText,
                              DateTime.now(), userId, user.profilePicture);
                          _messageController.clear();
                          setState(() {
                            key.currentState!.insertItem(0,
                                duration: const Duration(milliseconds: 200));
                            messages.insert(0, newMessage);
                          });
                          Message messageToSend = Message(
                              newMessage.id,
                              newMessage.text,
                              newMessage.dateTime,
                              newMessage.userId,
                              user.profilePictureName!);
                          ChatService()
                              .sendMessageEvent(messageToSend, widget.event.id);
                          print("JODER OSTIA;");
                        }
                      },
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

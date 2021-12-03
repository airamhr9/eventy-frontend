import 'package:eventy_front/components/pages/communities/post_comment.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/muro_service.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class PostDetails extends StatefulWidget {
  final PostObject post;
  const PostDetails(this.post) : super();

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails>
    with TickerProviderStateMixin {
  final key = GlobalKey<AnimatedListState>();
  final _commentController = TextEditingController();
  List<Message> comments = [];
  String userId = "";
  late User user;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate =
        DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(widget.post.date));
    MySharedPreferences.instance
        .getStringValue("userId")
        .then((value) => setState(() {
              userId = value;
              UserService().getUser(userId).then((value) {
                user = value;
              });
            }));
    MuroService().getPostComments(widget.post.id).then((value) {
      setState(() {
        comments.addAll(value);
        comments = comments.reversed.toList();
        for (int i = 0; i < comments.length; i++) {
          key.currentState!.insertItem(i);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 1))),
        child: Column(
          children: [
            Expanded(
                child: NestedScrollView(
                    headerSliverBuilder: (context, boolean) {
                      return [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (widget.post.images.length > 0)
                                  ? Column(
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ClipRRect(
                                              child: Image.network(
                                                widget.post.images,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.post.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF373737),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Por ',
                                        style: TextStyle(color: Colors.black54),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: widget.post.author,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: ' a $formattedDate'),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      widget.post.text,
                                      style:
                                          TextStyle(color: Color(0xFF484848)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ];
                    },
                    body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 10),
                            child: Text(
                              "Comentarios",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF373737),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 10),
                            child: AnimatedList(
                              physics: NeverScrollableScrollPhysics(),
                              key: key,
                              itemBuilder: (context, index, animation) {
                                return SlideTransition(
                                    position: animation.drive(Tween(
                                        begin: Offset(0, 2),
                                        end: Offset(0.0, 0.0))),
                                    child: Column(children: [
                                      PostComment(comments[index]),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ]));
                              },
                            ),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                        ]))),
            Container(
                color: Colors.black,
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: _commentController,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 25, left: 15),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            filled: true,
                            hintText: "Comentar"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        String messageText = _commentController.text.trim();
                        if (messageText.isNotEmpty) {
                          Message newMessage = Message(
                              "",
                              messageText,
                              DateTime.now(),
                              userId,
                              user.userName,
                              user.profilePicture);
                          _commentController.clear();
                          setState(() {
                            key.currentState!.insertItem(0,
                                duration: const Duration(milliseconds: 200));
                            comments.insert(0, newMessage);
                          });
                          Message commentToAdd = Message(
                              newMessage.id,
                              newMessage.text,
                              newMessage.dateTime,
                              newMessage.userId,
                              newMessage.userName,
                              user.profilePictureName!);
                          CommunityService()
                              .postComment(commentToAdd, widget.post.id);
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

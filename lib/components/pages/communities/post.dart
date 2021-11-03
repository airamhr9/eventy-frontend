import 'package:eventy_front/components/pages/communities/post_detail.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post extends StatelessWidget {
  final PostObject post;
  const Post(this.post) : super();

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(post.date));
    String commentLabel =
        (post.numComments == 1) ? "comentario" : "comentarios";

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PostDetails(post)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (post.images.length > 0)
                ? Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              post.images.first,
                              fit: BoxFit.fill,
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : SizedBox(),
            Text(
              post.title,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF373737),
                  overflow: TextOverflow.ellipsis),
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
                      text: post.author,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' a $formattedDate'),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              post.text,
              maxLines: 8,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis, color: Color(0xFF484848)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.comment_rounded,
                      size: 20,
                    ),
                    label: Text("${post.numComments} $commentLabel")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
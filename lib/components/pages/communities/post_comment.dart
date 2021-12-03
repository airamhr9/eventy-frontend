import 'package:eventy_front/objects/message.dart';
import 'package:flutter/material.dart';

class PostComment extends StatelessWidget {
  final Message comment;
  const PostComment(this.comment) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: CircleAvatar(
                backgroundImage: NetworkImage(comment.image),
                radius: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              comment.userName,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 46.0, right: 8),
          child: Text(
            comment.text,
            style: TextStyle(color: Color(0xFF313131)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.black,
          indent: 10,
          endIndent: 10,
        )
      ],
    );
  }
}

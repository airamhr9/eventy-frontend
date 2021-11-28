import 'package:eventy_front/objects/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment extends StatelessWidget {
  final Message message;
  const Comment(this.message) : super();

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.Hm().format(message.dateTime);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 + 100,
                  child: Text(
                    message.text,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(message.image),
                  radius: 16,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${message.userName} a las $date",
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
          ],
        ),
      ),
      Divider(
        thickness: 1,
        color: Colors.black,
      )
    ]);
  }
}

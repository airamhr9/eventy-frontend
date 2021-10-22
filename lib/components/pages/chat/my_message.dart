import 'package:eventy_front/objects/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyMessage extends StatelessWidget {
  final Message message;
  const MyMessage(this.message) : super();

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.Hm().format(message.dateTime);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Spacer(),
        Container(
          constraints: BoxConstraints(minWidth: 50, maxWidth: 300),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.text,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.white54),
              )
            ],
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          padding: EdgeInsets.only(bottom: 5),
          child: CircleAvatar(
            backgroundImage: NetworkImage(message.image),
            radius: 15,
          ),
        ),
      ],
    );
  }
}

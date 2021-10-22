import 'package:eventy_front/objects/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OtherMessage extends StatelessWidget {
  final Message message;
  const OtherMessage(this.message) : super();

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.Hm().format(message.dateTime);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          constraints: BoxConstraints(minWidth: 50, maxWidth: 300),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.grey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        Spacer(),
      ],
    );
  }
}

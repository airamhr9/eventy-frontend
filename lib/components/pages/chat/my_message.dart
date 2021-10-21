import 'package:eventy_front/objects/message.dart';
import 'package:flutter/material.dart';

class MyMessage extends StatelessWidget {
  final Message message;
  const MyMessage(this.message) : super();

  @override
  Widget build(BuildContext context) {
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
          child: Text(
            message.text,
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

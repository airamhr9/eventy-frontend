import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const BorderButton({required this.text, required this.onPressed}) : super();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => this.onPressed(),
        child: Text(this.text),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            elevation: 0,
            primary: Colors.transparent,
            onPrimary: Colors.black,
            textStyle: TextStyle(color: Colors.black),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(50))));
  }
}

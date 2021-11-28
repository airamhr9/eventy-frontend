import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const FilledButton({required this.text, required this.onPressed}) : super();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => this.onPressed,
        child: Text(this.text),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            primary: Colors.black,
            elevation: 0,
            textStyle: TextStyle(color: Colors.white),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))));
  }
}

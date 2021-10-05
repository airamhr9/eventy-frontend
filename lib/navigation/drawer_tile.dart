import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  DrawerTile(
      {required this.text,
      required this.icon,
      this.isSelected = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: isSelected
                  ? Colors.grey.withOpacity(0.12)
                  : Colors.transparent,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 13.0),
            child: Row(
              children: <Widget>[
                Icon(icon,
                    color: isSelected ? Colors.blueAccent : Colors.black54,
                    size: 24),
                SizedBox(width: 25.0),
                Text(text,
                    style: isSelected
                        ? TextStyle(fontSize: 18, color: Colors.blueAccent)
                        : TextStyle(fontSize: 18))
              ],
            )));
  }
}

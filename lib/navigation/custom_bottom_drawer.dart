import 'package:flutter/material.dart';
import 'package:eventy_front/navigation/navigation.dart';

import 'drawer_tile.dart';
import 'navigation_model.dart';

class CustomBottomDrawer extends StatefulWidget {
  const CustomBottomDrawer({Key? key}) : super(key: key);

  @override
  _CustomBottomDrawerState createState() => _CustomBottomDrawerState();
}

class _CustomBottomDrawerState extends State<CustomBottomDrawer> {
  int currentSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 10.0,
        child: Container(
            child: Column(children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 60.0, left: 15.0, bottom: 10.0),
              alignment: Alignment.topLeft,
              child: Text("Sports App",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          Expanded(
              child: ListView.builder(
            itemCount: EventsNavigation.titles.length,
            itemBuilder: (context, counter) {
              return DrawerTile(
                  onTap: () {
                    setState(() {
                      currentSelectedIndex = counter;
                    });
                  },
                  isSelected: currentSelectedIndex == counter,
                  text: navigationItems[counter].text,
                  icon: navigationItems[counter].icon);
            },
          ))
        ])));
  }
}

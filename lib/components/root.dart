import 'package:eventy_front/navigation/custom_bottom_drawer.dart';
import 'package:eventy_front/navigation/drawer_tile.dart';
import 'package:eventy_front/navigation/navigation.dart';
import 'package:eventy_front/navigation/navigation_model.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  final int selectedPage;

  Root({required this.selectedPage}) : super();

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  late Widget body;
  late String title;
  int currentSelectedIndex = 0;

  @override
  void initState() {
    body = EventsNavigation.getNavItem(widget.selectedPage);
    title = EventsNavigation.titles[widget.selectedPage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: body,
      drawer: CustomBottomDrawer(),
      drawerEnableOpenDragGesture: false,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  openBottomDrawer();
                },
                icon: Icon(Icons.menu_rounded)),
            Spacer(),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Unirse"),
        icon: Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void openBottomDrawer() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return Container(
              height: 280,
              padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: EventsNavigation.titles.length,
                itemBuilder: (context, counter) {
                  return DrawerTile(
                      onTap: () {
                        setState(() {
                          currentSelectedIndex = counter;
                          body = EventsNavigation.getNavItem(counter);
                          title = EventsNavigation.titles[counter];
                          Navigator.pop(context);
                        });
                      },
                      isSelected: currentSelectedIndex == counter,
                      text: navigationItems[counter].text,
                      icon: navigationItems[counter].icon);
                },
              ));
        });
  }
}

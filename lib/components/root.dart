import 'package:eventy_front/components/pages/communities/add_communities.dart';
import 'package:eventy_front/components/pages/my_events/add_event.dart';
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
  Color darkBlue = Color.fromARGB(255, 1, 31, 46);

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
        title: Text(
          title,
          style: TextStyle(color: darkBlue),
        ),
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
                icon: Icon(
                  Icons.menu_rounded,
                  color: darkBlue,
                )),
            Spacer(),
            IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: darkBlue,
                ),
                onPressed: () {}),
          ],
        ),
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
      ),
      floatingActionButton: getCurrentFab(context),
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

  Widget getCurrentFab(BuildContext context) {
    late Text label;
    late Icon icon;
    Function onPressed = () {};

    switch (currentSelectedIndex) {
      case EventsNavigation.NAV_HOME:
        {
          icon = Icon(Icons.person_add_rounded);
          label = Text("Unirse");
          break;
        }
      case EventsNavigation.NAV_SEARCH:
        {
          icon = Icon(Icons.search_rounded);
          label = Text("Buscar");
          break;
        }
      case EventsNavigation.NAV_COMMUNITY:
        {
          onPressed = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCommunity()),
            );
          };
          icon = Icon(Icons.add_rounded);
          label = Text("Crear comunidad");
          break;
        }
      case EventsNavigation.NAV_PROFILE:
        {
          icon = Icon(Icons.edit_rounded);
          label = Text("Editar");
          break;
        }
      case EventsNavigation.NAV_MY_EVENTS:
        {
          onPressed = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEvent()),
            );
          };
          icon = Icon(Icons.add_rounded);
          label = Text("Crear evento");
          break;
        }
      default:
        {
          icon = Icon(Icons.search_rounded);
          label = Text("Buscar");
          break;
        }
    }
    return FloatingActionButton.extended(
      onPressed: () => onPressed(),
      label: label,
      foregroundColor: Color.fromARGB(255, 1, 31, 46),
      icon: icon,
    );
  }
}

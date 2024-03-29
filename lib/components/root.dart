import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:eventy_front/components/pages/communities/add_communities.dart';
import 'package:eventy_front/components/pages/home/home.dart';
import 'package:eventy_front/components/pages/my_events/add_event.dart';
import 'package:eventy_front/components/pages/search/search.dart';
import 'package:eventy_front/navigation/drawer_tile.dart';
import 'package:eventy_front/navigation/navigation.dart';
import 'package:eventy_front/navigation/navigation_model.dart';
import 'package:eventy_front/components/pages/profile/profile_edit.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class Root extends StatefulWidget {
  final int selectedPage;

  Root({required this.selectedPage}) : super();

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  late Widget body;
  late String title;
  late int currentSelectedIndex;
  //Color darkBlue = Color.fromARGB(255, 1, 31, 46);

  @override
  void initState() {
    body = EventsNavigation.getNavItem(widget.selectedPage);
    title = EventsNavigation.titles[widget.selectedPage];
    currentSelectedIndex = widget.selectedPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: ValueKey("appbar"),
        title: Text(
          "OnPoint",
        ),
        elevation: 0,
        actions: (currentSelectedIndex == EventsNavigation.NAV_HOME)
            ? [
                IconButton(
                    onPressed: () {
                      (body as Home).homeState.saveEvent();
                    },
                    icon: Icon(Icons.bookmark_add))
              ]
            : (currentSelectedIndex == EventsNavigation.NAV_PROFILE)
                ? [
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Cerrar sesión"),
                          onTap: () {
                            logOut();
                          },
                        )
                      ],
                    )
                  ]
                : [],
        //backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFFAFAFA),
        foregroundColor: Colors.black,
      ),
      body: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 1))),
          child: body),
      bottomNavigationBar: CustomLineIndicatorBottomNavbar(
        unselectedIconSize: 25,
        selectedIconSize: 25,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        enableLineIndicator: true,
        customBottomBarItems: [
          CustomBottomBarItems(icon: Icons.home_outlined, label: ""),
          CustomBottomBarItems(icon: Icons.search, label: ""),
          CustomBottomBarItems(icon: Icons.add_box_outlined, label: ""),
          CustomBottomBarItems(icon: Icons.space_dashboard_outlined, label: ""),
          CustomBottomBarItems(icon: Icons.people_outline, label: "")
        ],
        selectedColor: Colors.black,
        unSelectedColor: Colors.black38,
        currentIndex: currentSelectedIndex,
        onTap: (index) {
          setState(() {
            currentSelectedIndex = index;
            body = EventsNavigation.getNavItem(index);
            title = EventsNavigation.titles[index];
          });
        },
      ),
      /*  drawer: CustomBottomDrawer(),
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
                  //color: darkBlue,
                )),
            Spacer(),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Cerrar sesión"),
                  onTap: () {
                    logOut();
                  },
                )
              ],
            )
          ],
        ),
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
      ),
      floatingActionButton: getCurrentFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, */
    );
  }

  void logOut() async {
    await MySharedPreferences.instance.setBooleanValue("isLoggedIn", false);
    Restart.restartApp();
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
          onPressed = () {
            (body as Home).homeState.buildMessageAddEvent(context);
          };
          icon = Icon(Icons.person_add_rounded);
          label = Text("Unirse");
          break;
        }
      case EventsNavigation.NAV_SEARCH:
        {
          onPressed = () {
            (body as Search).searchState.openBottomDrawer();
          };
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
          onPressed = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileEdit()),
            );
          };
          icon = Icon(Icons.edit_rounded);
          label = Text("Editar");
          break;
        }
      case EventsNavigation.NAV_MY_EVENTS:
        {
          onPressed = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEvent(-1)),
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
      //foregroundColor: Color.fromARGB(255, 1, 31, 46),
      icon: icon,
    );
  }
}

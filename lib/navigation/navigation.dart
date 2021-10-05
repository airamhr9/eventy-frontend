import 'package:flutter/cupertino.dart';
import '../components/pages/home.dart';

class EventsNavigation {
  static const NAV_HOME = 0;
  static const NAV_SEARCH = 1;
  static const NAV_COMMUNITY = 2;
  static const NAV_PROFILE = 3;
  static const titles = [
    "Home",
    "Búsqueda",
    "Comunidades",
    "Perfil",
  ];

  static Widget getNavItem(int navItem) {
    switch (navItem) {
      case NAV_HOME:
        return Home();
      case NAV_SEARCH:
        return Home();
      case NAV_COMMUNITY:
        return Home();
      case NAV_PROFILE:
        return Home();
      default:
        return Home();
    }
  }
}

import 'package:eventy_front/components/pages/my_events/add_event.dart';
import 'package:eventy_front/components/pages/communities/communities.dart';
import 'package:eventy_front/components/pages/home.dart';
import 'package:eventy_front/components/pages/my_events/my_events.dart';
import 'package:eventy_front/components/pages/profile.dart';
import 'package:eventy_front/components/pages/search.dart';
import 'package:flutter/material.dart';

class EventsNavigation {
  static const NAV_HOME = 0;
  static const NAV_SEARCH = 1;
  static const NAV_COMMUNITY = 2;
  static const NAV_PROFILE = 3;
  static const NAV_MY_EVENTS = 4;
  static const titles = [
    "Home",
    "Búsqueda",
    "Comunidades",
    "Perfil",
    "Mis Eventos"
  ];

  static Widget getNavItem(int navItem) {
    switch (navItem) {
      case NAV_HOME:
        return Home();
      case NAV_SEARCH:
        return Search();
      case NAV_COMMUNITY:
        return Communities();
      case NAV_PROFILE:
        return Profile();
      case NAV_MY_EVENTS:
        return MyEvents();
      default:
        return Home();
    }
  }
}

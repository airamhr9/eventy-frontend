import 'package:flutter/material.dart';

class NavigationModel {
  String text;
  IconData icon;

  NavigationModel({required this.text, required this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(text: "Home", icon: Icons.home),
  NavigationModel(text: "Búsqueda", icon: Icons.search_rounded),
  NavigationModel(text: "Comunidades", icon: Icons.people_rounded),
  NavigationModel(text: "Perfil", icon: Icons.person),
  NavigationModel(text: "Mis eventos", icon: Icons.calendar_today_rounded)
];

import 'package:flutter/material.dart';

class NavigationModel {
  String text;
  IconData icon;

  NavigationModel({required this.text, required this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(text: "Eventos para ti", icon: Icons.home),
  NavigationModel(text: "Búsqueda", icon: Icons.search_rounded),
  NavigationModel(text: "Mis Comunidades", icon: Icons.people_rounded),
  NavigationModel(text: "Perfil", icon: Icons.person_rounded),
  NavigationModel(text: "Mis eventos", icon: Icons.calendar_today_rounded)
];

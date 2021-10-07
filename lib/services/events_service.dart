import 'package:eventy_front/services/service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:eventy_front/objects/event.dart';

class EventService {
  @override
  String url = "";

  Future<List<Eventy>> get() async {
    //sustituir por llamada a server
    print("Here service");
    final String response =
        await rootBundle.loadString('mock_data/events.json');
    final data = await json.decode(response) as List;
    List<Eventy> events = data.map((event) => Eventy.fromJson(event)).toList();
    return events;
  }
}

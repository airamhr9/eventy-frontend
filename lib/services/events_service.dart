import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eventy_front/services/service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:eventy_front/objects/event.dart';

class EventService {
  @override
  String url = "";

  Future<List<Event>> get() async {
    //sustituir por obtener localizacion
    final query = {
      'userId': '0',
      'latitude': '39.357081',
      'longitude': '-0.324842'
    };
    Uri url = Uri.http("localhost:8000", '/recomend', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body) as List;
    List<Event> events = data.map((event) => Event.fromJson(event)).toList();
    return events;
  }
}

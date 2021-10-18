import 'dart:io';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eventy_front/objects/event.dart';
import 'package:path/path.dart';

class EventService {
  String url = "10.0.2.2:8000";
  //String url = "localhost:8000";

  Future<List<Event>> get() async {
    //sustituir por obtener localizacion
    LatLng position = await LocationService.determinePosition();
    final query = {
      'userId': '0',
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString()
    };
    Uri url = Uri.http(this.url, '/recomend', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    final list = data["items"] as List;
    List<Event> events = list.map((event) => Event.fromJson(event)).toList();
    return events;
  }

  Future<List<Event>> search(String text, List<String> tags) async {
    final query = {'text': text, 'tags': tags};
    Uri url = Uri.http(this.url, '/search', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data as List;
    List<Event> events = list.map((event) => Event.fromJson(event)).toList();
    return events;
  }

  Future<bool> sendImage(FileImage image) async {
    final query = {'type': 'event', 'name': basename(image.file.path)};
    Uri url = Uri.http(this.url, '/images', query);
    final request = http.MultipartRequest("POST", url);
    final imageToSend =
        await http.MultipartFile.fromPath('photo', image.file.path);
    request.files.add(imageToSend);
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<List<User>> getParticipants(int eventId) async {
    final query = {'eventId': eventId};
    Uri url = Uri.http(this.url, '/events', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    final list = data['items'] as List;
    List<User> participantsList = list.cast();
    return participantsList;
  }
}

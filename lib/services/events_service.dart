import 'dart:io';
import 'package:eventy_front/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eventy_front/objects/event.dart';

class EventService {
  String url = "localhost:8000";

  Future<List<Event>> get() async {
    //sustituir por obtener localizacion
    Position position = await LocationService.determinePosition();
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
}

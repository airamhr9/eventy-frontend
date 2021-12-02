import 'dart:io';
import 'package:eventy_front/objects/survey.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/location_service.dart';
import 'package:eventy_front/services/service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:eventy_front/objects/event.dart';
import 'package:path/path.dart';

class EventService extends Service {
  Future<List<Event>> get() async {
    //sustituir por obtener localizacion
    LatLng position = await LocationService.determinePosition();
    final query = {
      'userId': await MySharedPreferences.instance.getStringValue("userId"),
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString()
    };
    print(query['userId']);
    Uri url = Uri.http(this.url, '/recomend', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    final list = data["items"] as List;
    List<Event> events = list.map((event) => Event.fromJson(event)).toList();
    return events;
  }

  Future<List<Event>> getHistory() async {
    //sustituir por obtener localizacion
    final query = {
      'id': await MySharedPreferences.instance.getStringValue("userId"),
      'olderEvents': "true"
    };
    Uri url = Uri.http(this.url, '/users', query);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data as List;
    List<Event> events = list.map((event) => Event.fromJson(event)).toList();
    return events;
  }

  Future<List<Event>> getFutureEvents() async {
    //sustituir por obtener localizacion
    final query = {
      'userId': await MySharedPreferences.instance.getStringValue("userId"),
      'futureEvents': "true"
    };
    Uri url = Uri.http(this.url, '/users', query);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data as List;
    List<Event> events = list.map((event) => Event.fromJson(event)).toList();
    return events;
  }

  Future<List<Event>> getSeeLaterEvents() async {
    //sustituir por obtener localizacion
    final query = {
      'userId': await MySharedPreferences.instance.getStringValue("userId"),
    };
    Uri url = Uri.http(this.url, '/seeItLater', query);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print("SEE LATER DATA" + data.toString());
    final list = data as List;
    List<Event> events = list.map((event) => Event.fromJson(event)).toList();
    return events;
  }

  Future<List<Event>> search(
      String text, List<String> tags, Map<String, dynamic> filters) async {
    final query = {'text': text, 'tags': tags};
    if (filters.keys.length > 0) {
      query['enabled'] = true.toString();
      filters.keys.forEach((element) {
        query[element] = filters[element].toString();
      });
    }
    print(query);
    Uri url = Uri.http(this.url, '/search', query);
    print("URL $url");
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data as List;
    List<Event> events = list.map((event) => Event.fromJson(event)).toList();
    return events;
  }

  Future<List<Event>> getRelatedEvents(
      int eventId, List<String> tags, double latitud, double longitud) async {
    final query = {
      'eventId': eventId.toString(),
      'lat': latitud.toString(),
      'long': longitud.toString(),
      'tags': tags
    };
    Uri url = Uri.http(this.url, '/related', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data['items'] as List;
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

  Future<bool> sendImages(List<FileImage> images) async {
    final query = {
      'type': 'event',
    };
    Uri url = Uri.http(this.url, '/images', query);
    final request = http.MultipartRequest("POST", url);
    await Future.forEach(images, (img) async {
      img as FileImage;
      request.files.add(await http.MultipartFile.fromPath(
          'photos', img.file.path,
          filename: basename(img.file.path)));
    });
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<bool> postEvent(Event event) async {
    Uri url = Uri.http(this.url, '/events');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url,
        headers: headers, body: jsonEncode(event.toJson()));
    return response.statusCode == 200;
  }

  Future<bool> putEvent(Event event) async {
    final query = { 'event': event.id };
    Uri url = Uri.http(this.url, '/events', query);
    final headers = { HttpHeaders.contentTypeHeader: 'application/json' };
    final response = await http.post(url,
        headers: headers, body: jsonEncode(event.toJson()));
    return response.statusCode == 200;
  }

  Future<bool> saveEvent(int eventId) async {
    var userId = await MySharedPreferences.instance.getStringValue("userId");
    final query = {'userId': userId, 'eventId': eventId.toString()};
    Uri url = Uri.http(this.url, '/seeItLater', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }

  Future<List<List<User>>> getParticipants(String eventId) async {
    final query = {'participants': "0", 'id': eventId};
    Uri url = Uri.http(this.url, '/events', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    final list = data as List;
    print("lista de participantes: ");
    print(list);
    print("Fin de lista");

    List<User> participantsList = (list[0] as List)
        .map((participant) => User.fromJson(participant))
        .toList();
    List<User> possiblyParticipantsList = (list[1] as List)
        .map((participant) => User.fromJson(participant))
        .toList();
    return [participantsList, possiblyParticipantsList];
  }

  Future<bool> sendNewParticipant(
      String eventId, String userId, String confirmed) async {
    final query = {
      'eventId': eventId,
      'userId': userId,
      'confirmed': confirmed
    };
    Uri url = Uri.http(this.url, '/joinEvent', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }

  Future<List> getUserScoreAndEventAverage(
      String eventId, String userId) async {
    final query = {
      'user': userId,
      'event': eventId,
    };
    Uri url = Uri.http(this.url, '/eventScores', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    return data;
  }

  Future<bool> postUserScore(
      String eventId, String userId, String score) async {
    final query = {
      'user': userId,
      'event': eventId,
      'score': score,
    };
    Uri url = Uri.http(this.url, '/eventScores', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }

  Future<bool> postSurvey(Survey survey, String eventId) async {
    final query = {'event': eventId};
    Uri url = Uri.http(this.url, '/surveys', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url,
        headers: headers, body: jsonEncode(survey.toJson()));
    return response.statusCode == 200;
  }

  Future<int> postDateSurvey(Survey survey) async {
    final query = { 'newEvent': 'true' };
    Uri url = Uri.http(this.url, '/surveys', query);
    final headers = { HttpHeaders.contentTypeHeader: 'application/json' };
    final response = await http.post(url,
        headers: headers, body: jsonEncode(survey.toJson()));
    return int.parse(response.body);
  }

  Future<bool> postSurveyVote(
      String eventId, String surveyId, String option) async {
    print(option);
    final query = {
      'event': eventId,
      'survey': surveyId,
      'option': option,
      'user': await MySharedPreferences.instance.getStringValue("userId")
    };
    Uri url = Uri.http(this.url, '/votes', query);
    print(url);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }

  Future<List<Survey>> getSurveys(String eventId) async {
    final query = {
      'event': eventId,
      'user': await MySharedPreferences.instance.getStringValue("userId")
    };
    Uri url = Uri.http(this.url, '/surveys', query);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    final list = data as List;
    List<Survey> surveys =
        list.map((survey) => Survey.fromJson(survey)).toList();
    return surveys;
  }
}

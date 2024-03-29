import 'dart:io';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class CommunityService extends Service {
  Future<List<Community>> get() async {
    final query = {
      'user': await MySharedPreferences.instance.getStringValue("userId"),
    };
    Uri url = Uri.http(this.url, '/communities', query);
    print(url);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    final list = data as List;
    print(data);
    List<Community> communities =
        list.map((community) => Community.fromJson(community)).toList();
    print(communities);
    return communities;
  }

  Future<Community> getCommunity(int commId) async {
    final query = {
      'id': commId.toString(),
    };
    Uri url = Uri.http(this.url, '/communities', query);
    print(url);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    Community community = Community.fromJson(data);
    return community;
  }

  Future<bool> post(Community community) async {
    final body = json.encode(community);
    Uri url = Uri.http(this.url, '/communities');
    //final request = http.Request("POST", url);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    return response.statusCode == 200;
  }

  Future<bool> sendImage(FileImage image) async {
    final query = {'type': 'community', 'name': basename(image.file.path)};
    Uri url = Uri.http(this.url, '/images', query);
    final request = http.MultipartRequest("POST", url);
    final imageToSend =
        await http.MultipartFile.fromPath('photo', image.file.path);
    request.files.add(imageToSend);
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<List<Community>> search(String text, List<String> tags) async {
    final query = {'text': text, 'tags': tags};
    Uri url = Uri.http(this.url, '/searchComm', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data as List;
    List<Community> communities =
        list.map((event) => Community.fromJson(event)).toList();
    return communities;
  }

  Future<bool> sendImages(List<FileImage> images) async {
    final query = {
      'type': 'community',
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

  Future<bool> sendNewMember(String communityId, String userId) async {
    print("COMM ID $communityId USERID $userId");
    final query = {'communityId': communityId, 'userId': userId};
    Uri url = Uri.http(this.url, '/joinCommunity', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }

  Future<bool> postComment(Message message, String postId) async {
    final query = {
      'idPost': postId,
    };
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    Uri url = Uri.http(this.url, '/comment', query);
    final response = await http.post(url,
        body: json.encode(message.toJson()), headers: headers);
    return response.statusCode == 200;
  }

  Future<List<Event>> getCommunityEvents(int communityId) async {
    final query = {
      'commId': communityId.toString(),
    };
    Uri url = Uri.http(this.url, '/eventsComm', query);
    print(url);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    final list = data as List;
    //print("GET COMMUNITY EVENTS:");
    //print(data);
    List<Event> events = list.map((events) => Event.fromJson(events)).toList();
    //print(events);
    return events;
  }

  Future<bool> postEvent(Event event, int id) async {
    final query = {
      'commId': id.toString(),
    };
    Uri url = Uri.http(this.url, '/eventsComm', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url,
        headers: headers, body: jsonEncode(event.toJson()));
    return response.statusCode == 200;
  }
}

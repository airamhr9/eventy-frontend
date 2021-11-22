import 'dart:convert';
import 'dart:io';

import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/group_request.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/objects/user_group.dart';
import 'package:eventy_front/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GroupService extends Service {
  Future<List<Group>> getGroups(String userId) async {
    final query = {'user': userId, 'type': 'JOINED'};
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    //print(data);
    final list = data as List;
    List<Group> groups = list.map((groups) => Group.fromJson(groups)).toList();
    return groups;
  }

  Future<List<GroupRequest>> getRequests(String userId) async {
    final query = {'user': userId, 'type': 'REQUESTS'};
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    //print("THIS IS REQUESTS " + data.toString());
    final list = data as List;
    List<GroupRequest> users =
        list.map((grequest) => GroupRequest.fromJson(grequest)).toList();
    return users;
  }

  Future<bool> createGroup(
      String creatorId, List<String> requestedUserId) async {
    String ids = "";
    requestedUserId.forEach((element) {
      ids += element + ",";
    });
    ids = ids.substring(0, ids.length - 1);
    final query = {'creator': creatorId};
    Uri url = Uri.http(this.url, '/groups/$ids', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.post(url, headers: headers);
    return localhostResponse.statusCode == 200;
  }

  Future<bool> sendInvite(String groupId, List<String> requestedUserId) async {
    final query = {'group': groupId, 'op': 'REQUEST'};
    Uri url = Uri.http(this.url, '/groups', query);
    //print(requestedUserId);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.put(url,
        headers: headers, body: json.encode(requestedUserId));
    return localhostResponse.statusCode == 200;
  }

  Future<bool> updateUser(String groupId, Map<String, dynamic> filters,
      {String? userId}) async {
    final query = {'group': groupId};
    if (userId != null) {
      query['user'] = userId;
    }
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse =
        await http.put(url, headers: headers, body: json.encode(filters));
    return localhostResponse.statusCode == 200;
  }

  Future<bool> rejectGroupRequest(String groupId, String userId) async {
    final query = {'op': 'REJECT', 'group': groupId, 'user': userId};
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.put(url, headers: headers);
    return localhostResponse.statusCode == 200;
  }

  Future<List<dynamic>> getRecomendedEvents(String groupId) async {
    print("estoy dentrooo");
    final query = {'group': groupId};
    Uri url = Uri.http(this.url, '/searchGroups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    print("esperando respuesta");
    final localhostResponse = await http.get(url, headers: headers);
    print("ya tengo la respuesta");
    final data = await json.decode(localhostResponse.body);
    Map map = data as Map<String, dynamic>;
    bool todoOk = map.values.first;
    List events = [];
    map.remove(map.keys.first);
    if (todoOk == true) {
      events = map.values.map((event) => Event.fromJson(event)).toList();
    } else {
      for (List list in map.values) {
        print(list.length);
        events.add(list.map((event) => Event.fromJson(event)).toList());
        print(events.toString());
      }
    }
    print(events);
    return events;
  }

  Future<bool> sendGroupUsersToEvent(String groupId, String eventId) async {
    final query = {'groupId': groupId, 'eventId': eventId};
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.put(url, headers: headers);
    return localhostResponse.statusCode == 200;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:eventy_front/objects/event.dart';
import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/group_request.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/objects/user_group.dart';
import 'package:eventy_front/services/service.dart';
import 'package:http/http.dart' as http;

class GroupService extends Service {
  Future<List<Group>> getGroups(String userId) async {
    final query = {'user': userId, 'type': 'JOINED'};
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    print(data);
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
    print("THIS IS REQUESTS " + data.toString());
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
    print(requestedUserId);
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
    final query = {'groupId': groupId};
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    final dataList = data as List;
    print(data);
    List<List<dynamic>> resultList = [];
    List events = [];
    if (dataList[0] == true) {
      // todo ha ido bien
      if (dataList.length == 2) {
        // me han pasado solo 1 lista de eventos
        final list = dataList[1] as List;
        resultList.add(list);
        events = resultList.map((eventList) {
          for (dynamic event in eventList) {
            Event.fromJson(event);
          }
        }).toList();
        return events;
      } else {
        var aux;
        // me han pasado 3 listas de eventos
        if (data[1] != []) {
          aux = data[1] as List;
          resultList.add(aux);
        } else {
          resultList.add([]);
        }
        if (data[2] != []) {
          aux = data[2] as List;
          resultList.add(aux);
        } else {
          resultList.add([]);
        }
        if (data[3] != []) {
          aux = data[3] as List;
          resultList.add(aux);
        } else {
          resultList.add([]);
        }
        events = resultList.map((eventList) {
          if (eventList != []) {
            for (dynamic event in eventList) {
              Event.fromJson(event);
            }
          }
        }).toList();
        return events;
      }
    } else {
      return events;
    }
  }

  Future<bool> sendGroupUsersToEvent(String groupId, String eventId) async {
    final query = {'groupId': groupId, 'eventId': eventId};
    Uri url = Uri.http(this.url, '/groups', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.put(url, headers: headers);
    return localhostResponse.statusCode == 200;
  }
}

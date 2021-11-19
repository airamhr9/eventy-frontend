import 'dart:convert';
import 'dart:io';

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

  Future<bool> updateUser(String groupId, Map<String, dynamic> filters) async {
    final query = {'group': groupId};
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
}

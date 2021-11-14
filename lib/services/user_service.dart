import 'dart:io';

import 'package:eventy_front/objects/login_response.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class UserService {
  String url = "10.0.2.2:8000";
  //String url = "localhost:8000";
  //String url = "eventyserver.herokuapp.com";

  List<String> tags = [];

  Future<List<String>> getUserPreferences(
      String userId, String preferences) async {
    print("Llamando a server" + userId);
    final query = {'id': userId, 'preferences': preferences};
    Uri url = Uri.http(this.url, '/users', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);

    for (var tag in data) {
      tags.add(tag);
    }
    return tags;
  }

  Future<LoginResponse> login(String username, String password) async {
    final query = {'username': username, 'password': password};
    Uri url = Uri.http(this.url, '/login', query);

    final response = await http.get(url);
    if (response.body.toString().startsWith("Error:")) {
      return LoginResponse(false, "", response.body.toString());
    } else {
      return LoginResponse(true, response.body.toString(), "");
    }
  }

  Future<List<User>> search(String text) async {
    final query = {'search': text};
    Uri url = Uri.http(this.url, '/searchUsers', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data as List;
    List<User> users = list.map((user) => User.fromJson(user)).toList();
    return users;
  }

  Future<String> register(User user) async {
    final query = {
      'username': user.userName,
      'password': user.password,
      'email': user.email,
      'birthdate': user.birthdate,
    };
    Uri url = Uri.http(this.url, '/register', query);
    final response = await http.post(
      url,
    );
    return response.body;
  }

  Future<String> updateUser(User user) async {
    //final query = {'body': };
    Uri url = Uri.http(this.url, '/users');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.put(url, headers: headers, body: json.encode(user.toJson()));
    print(response.body);
    return response.body;
  }

  Future<User> getUser(String userId) async {
    final query = {"id": userId};
    Uri url = Uri.http(this.url, '/users', query);
    final response = await http.get(url);
    print(response.body);
    final data = await json.decode(response.body);
    return User.fromJson(data);
  }

  Future<bool> sendImage(FileImage image) async {
    final query = {'type': 'user', 'name': basename(image.file.path)};
    Uri url = Uri.http(this.url, '/images', query);
    final request = http.MultipartRequest("POST", url);
    final imageToSend =
        await http.MultipartFile.fromPath('photo', image.file.path);
    request.files.add(imageToSend);
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<List<List<User>>> getFriends(String userId) async {
    final query = {'user': userId};
    Uri url = Uri.http(this.url, '/friends', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    final friendsAndRequests = (data as List);
    print(friendsAndRequests);
    List<User> friendsList = (friendsAndRequests[0] as List)
        .map((participant) => User.fromJson(participant))
        .toList();
    List<User> requestsList = (friendsAndRequests[1] as List)
        .map((participant) => User.fromJson(participant))
        .toList();
    return [friendsList, requestsList];
  }

  Future<bool> handleFriendRequest(
      String userId, String requestUserName, String response) async {
    final query = {
      'op': response,
      'userId1': userId,
      'username2': requestUserName
    };
    Uri url = Uri.http(this.url, '/friends', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.post(url, headers: headers);
    return localhostResponse.statusCode == 200;
  }
}

import 'dart:io';

import 'package:eventy_front/objects/login_response.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  String url = "10.0.2.2:8000";
  //String url = "localhost:8000";

  List<String> tags = [];

  Future<List<String>> getUserPreferences(
      String userId, String preferences) async {
    print("Llamando a server" + userId);
    final query = { 'id': userId, 'preferences': preferences};
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

  Future<String> updateUser(String userId, String body) async {
    final query = {"id": userId, 'body': body};
    Uri url = Uri.http(this.url, '/users', query);
    final response = await http.put(url);
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
}

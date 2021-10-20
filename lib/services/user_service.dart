import 'dart:io';

import 'package:eventy_front/objects/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  String url = "10.0.2.2:8000";
 // String url = "localhost:8000";

  List<String> tags = [];

Future<List<String>> getUserPreferences(String res, String userId)async{
  print("Llamando a server");
  final query = {'res': res, 'userId': userId};
  Uri url = Uri.http(this.url, '/userPreferences', query);
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final localhostResponse = await http.get(url, headers: headers);
  print("RESPONSE " + localhostResponse.body.toString());
  final data = await json.decode(localhostResponse.body);
  for (var tag in data) {
    tags.add(tag);
  }
  return tags;
}


  Future<bool> login(String username, String password) async {
    final query = {'username': username, 'password': password};
    Uri url = Uri.http(this.url, '/login', query);

    final response = await http.get(url);

    return response.statusCode == 200;
  }
}

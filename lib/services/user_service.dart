import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  //String url = "10.0.2.2:8000";
  String url = "localhost:8000";

  Future<bool> login(String username, String password) async {
    final query = {'username': username, 'password': password};
    Uri url = Uri.http(this.url, '/login', query);

    final response = await http.get(url);

    return response.statusCode == 200;
  }
}

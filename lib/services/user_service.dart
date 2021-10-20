import 'package:eventy_front/objects/login_response.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  String url = "10.0.2.2:8000";
  //String url = "localhost:8000";

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

  void register(User user) async {
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
    print(response.body);
  }
}

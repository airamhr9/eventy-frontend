import 'dart:io';
import 'package:eventy_front/objects/community.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityService {
  @override
  String url = "localhost:8000";

  /*Future<List<Community>> get() async {
    Uri url = Uri.http(this.url, '/community');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    final list = data["items"] as List;
    List<Community> communities =
        list.map((community) => Community.fromJson(community)).toList();
    return communities;
  }*/

  Future<List<Community>> get() async {
    //sustituir por llamada a server
    print("Here service");
    final String response =
        await rootBundle.loadString('mock_data/communities.json');
    final data = await json.decode(response) as List;
    List<Community> communities =
        data.map((community) => Community.fromJson(community)).toList();
    return communities;
  }
}

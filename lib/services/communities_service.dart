import 'dart:io';
import 'package:eventy_front/objects/community.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityService {
  @override
  String url = "";

  Future<List<Community>> get() async {
    Uri url = Uri.http(this.url, '/community');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    final list = data["items"] as List;
    List<Community> communities =
        list.map((community) => Community.fromJson(community)).toList();
    return communities;
  }
}

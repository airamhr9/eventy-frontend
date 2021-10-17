import 'dart:io';
import 'package:eventy_front/objects/community.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityService {
  //String url = "10.0.2.2:8000";
  String url = "localhost:8000";

  Future<List<Community>> get() async {
    final query = {
      'user': '0',
    };
    Uri url = Uri.http(this.url, '/communities', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    final list = data as List;
    List<Community> communities =
        list.map((community) => Community.fromJson(community)).toList();
    return communities;
  }

  Future<Community> post(Community community) async {
    final query = {
      'community': community,
    };
    Uri url = Uri.http(this.url, '/communities', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    http.post(url, headers: headers);
    return community;
  }
}

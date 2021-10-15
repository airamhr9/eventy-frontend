import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/services/service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
    List<Community> communities = list.map((community) => Event.fromJson(community)).toList();
    return communities;
  }
}

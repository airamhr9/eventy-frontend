import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TagsService {
  String url = "localhost:8000";

  Future<List<dynamic>> get() async {
    Uri url = Uri.http(this.url,'/tag');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    final list = data["items"] as List;
    List<Tag> tags = list.map((tag) => Tag.fromJson(tag)).toList();    r
    return tags;
  }
}
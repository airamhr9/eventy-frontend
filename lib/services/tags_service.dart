import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TagsService {
  //String url = "10.0.2.2:8000";
  String url = "localhost:8000";

  List<String> tags = [];

  Future<List<String>> get() async {
    Uri url = Uri.http(this.url, '/tags');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    for (var tag in data) {
      tags.add(tag);
    }
    return tags;
  }
}

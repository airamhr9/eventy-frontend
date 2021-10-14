import 'dart:io';
import 'package:eventy_front/objects/tag.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TagsService {
  String url = "localhost:8000";

  Future<List<Tag>> get() async {
    //sustituir por obtener localizacion
    final query = {
      'userId': '0',
    };
    Uri url = Uri.http(this.url, '/recomend', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    //print("RESPONSE " + localhostResponse.body.toString());
    final data = await json.decode(localhostResponse.body);
    final list = data["items"] as List;
    List<Tag> tags = list.map((tags) => Tag.fromJson(tags)).toList();
    return tags;
  }
}
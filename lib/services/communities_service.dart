import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/services/service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CommunityService {
  @override
  String url = "";

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

import 'dart:io';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class CommunityService {
  String url = "10.0.2.2:8000";
  //String url = "localhost:8000";

  Future<List<Community>> get(String userId) async {
    final query = {
      'user': userId,
    };
    Uri url = Uri.http(this.url, '/communities', query);
    print(url);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final localhostResponse = await http.get(url, headers: headers);
    final data = await json.decode(localhostResponse.body);
    final list = data as List;
    print(data);
    List<Community> communities =
        list.map((community) => Community.fromJson(community)).toList();
    print(communities);
    return communities;
  }

  Future<bool> post(Community community) async {
    final body = json.encode(community);
    Uri url = Uri.http(this.url, '/communities');
    //final request = http.Request("POST", url);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    return response.statusCode == 200;
  }

  Future<bool> sendImage(FileImage image) async {
    final query = {'type': 'community', 'name': basename(image.file.path)};
    Uri url = Uri.http(this.url, '/images', query);
    final request = http.MultipartRequest("POST", url);
    final imageToSend =
        await http.MultipartFile.fromPath('photo', image.file.path);
    request.files.add(imageToSend);
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<bool> sendImages(List<FileImage> images) async {
    final query = {
      'type': 'community',
    };
    Uri url = Uri.http(this.url, '/images', query);
    final request = http.MultipartRequest("POST", url);
    await Future.forEach(images, (img) async {
      img as FileImage;
      request.files.add(await http.MultipartFile.fromPath(
          'photos', img.file.path,
          filename: basename(img.file.path)));
    });
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<bool> sendNewMember(String communityId, String userId) async {
    final query = {'communityId': communityId, 'userId': userId};
    Uri url = Uri.http(this.url, '/community', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }
}

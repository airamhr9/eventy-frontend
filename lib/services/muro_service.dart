import 'dart:convert';
import 'dart:io';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/services/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class MuroService extends Service {
  Future<List<PostObject>> getCommunityMuro(int communityId) async {
    final query = {'idCommunity': communityId.toString()};

    Uri url = Uri.http(this.url, '/allPosts', query);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final postList = data as List;
    List<PostObject> posts =
        postList.map((post) => PostObject.fromJson(post)).toList();
    return posts;
  }

  Future<List<Message>> getPostComments(String postId) async {
    final query = {'idPost': postId};
    Uri url = Uri.http(this.url, '/comments', query);
    print(url);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data['comments'] as List;
    List<Message> comments =
        list.map((comments) => Message.fromJson(comments)).toList();
    return comments;
  }

  Future<bool> newPost(PostObject post, String id) async {
    final query = {
      'idCommunity': id,
      'title': post.title,
      'text': post.text,
      'date': post.date,
      'author': post.author,
      'images': post.images
    };
    Uri url = Uri.http(this.url, '/post', query);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(url, headers: headers);
    return response.statusCode == 200;
  }

  Future<bool> sendImage(FileImage image) async {
    final query = {'type': 'post', 'name': basename(image.file.path)};
    Uri url = Uri.http(this.url, '/images', query);
    final request = http.MultipartRequest("POST", url);
    final imageToSend =
        await http.MultipartFile.fromPath('photo', image.file.path);
    request.files.add(imageToSend);
    var response = await request.send();
    return response.statusCode == 200;
  }
}

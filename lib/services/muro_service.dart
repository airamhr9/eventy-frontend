import 'dart:collection';
import 'dart:convert';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/services/service.dart';
import 'package:http/http.dart' as http;

class MuroService extends Service {
  Future<List<PostObject>> getCommunityMuro(int communityId) async {
    final query = {'idCommunity': communityId.toString()};

    Uri url = Uri.http(this.url, '/allPosts', query);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    try {
      (data as List).length;
      return [];
    } catch (e) {
      final postsMap = data as LinkedHashMap<String, dynamic>;
      List<String> list = postsMap.keys.toList();
      List<PostObject> posts =
      list.map((post) => PostObject.fromJson(postsMap[post])).toList();
      return posts;
    }

  }

  Future<List<Message>> getMuroComments(String muroId) async {
    final query = {'muroId': muroId};
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

  Future <bool> newPost(PostObject post) async{
    final body = json.encode(post);
    Uri url = Uri.http(this.url, '/post');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    return response.statusCode == 200;
  }

}

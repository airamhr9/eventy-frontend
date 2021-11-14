import 'dart:collection';
import 'dart:convert';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:http/http.dart' as http;

class MuroService {
  //String url = "10.0.2.2:8000";
  //String url = "localhost:8000";
  String url = "eventyserver.herokuapp.com";

  Future<List<PostObject>> getCommunityMuro(int communityId) async {
    final query = {'idCommunity': communityId.toString()};

    Uri url = Uri.http(this.url, '/allPosts', query);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final postsMap = data as LinkedHashMap<String, dynamic>;
    List<String> list = postsMap.keys.toList();
    List<PostObject> posts =
        list.map((post) => PostObject.fromJson(postsMap[post])).toList();
    return posts;
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
}

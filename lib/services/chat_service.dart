import 'dart:convert';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:http/http.dart' as http;

class ChatService {
  String url = "10.0.2.2:8000";
  //String url = "localhost:8000";

  Future<List<Message>> getCommunityMessages(int commId) async {
    final query = {'commId': commId.toString()};
    Uri url = Uri.http(this.url, '/chatComm', query);
    //print(url);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data['messages'] as List;
    List<Message> messages =
        list.map((message) => Message.fromJson(message)).toList();
    return messages;
  }
}

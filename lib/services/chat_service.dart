import 'dart:convert';
import 'dart:io';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/services/service.dart';
import 'package:http/http.dart' as http;

class ChatService extends Service {

  Future<List<Message>> getEventMessages(int eventId) async {
    final query = {'eventId': eventId.toString()};
    Uri url = Uri.http(this.url, '/chat', query);
    //print(url);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data['messages'] as List;
    List<Message> messages =
        list.map((message) => Message.fromJson(message)).toList();
    return messages;
  }

  Future<bool> sendMessageEvent(Message message, int eventId) async {
    final query = {'eventId': eventId.toString()};
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    Uri url = Uri.http(this.url, '/chat', query);
    print("here message");
    print("MESSAGE\n" + message.toJson().toString());
    final response = await http.post(url,
        body: json.encode(message.toJson()), headers: headers);
    return response.statusCode == 200;
  }

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

  Future<bool> sendMessageCommunity(Message message, int communityId) async {
    final query = {'commId': communityId.toString()};
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    Uri url = Uri.http(this.url, '/chatComm', query);
    print("here message");
    print("MESSAGE\n" + message.toJson().toString());
    final response = await http.post(url,
        body: json.encode(message.toJson()), headers: headers);
    return response.statusCode == 200;
  }
}

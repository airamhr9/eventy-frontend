import 'dart:convert';
import 'dart:io';
import 'package:eventy_front/components/pages/communities/post.dart';
import 'package:eventy_front/objects/message.dart';
import 'package:eventy_front/objects/post.dart';
import 'package:http/http.dart' as http;

class MuroService {
  String url = "10.0.2.2:8000";
  //String url = "localhost:8000";

  Future<List<Message>> getMuroComments(String muroId) async {
/*     final query = {'muroId': muroId};
    Uri url = Uri.http(this.url, '/muroComments', query);
    //print(url);
    final localhostResponse = await http.get(url);
    final data = await json.decode(localhostResponse.body);
    print(data);
    final list = data['comments'] as List;
    List<Message> comments =
        list.map((comments) => Message.fromJson(comments)).toList();
    return comments; */
    return [
      Message(
          "",
          "la verdad que menuda mierda de post, eres tonto o qué",
          DateTime.now(),
          "Antonio perez",
          "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fusers%2FuserImg.jpg?alt=media&token=9a12a294-94c9-4e76-8eae-86a17054bbe0"),
      Message(
          "",
          "la verdad que un buen post, eres inteligente o qué",
          DateTime.now(),
          "Evil Antonio",
          "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fusers%2FuserImg.jpg?alt=media&token=9a12a294-94c9-4e76-8eae-86a17054bbe0"),
      Message(
          "",
          "gracias amigo te lo agradezco 10/10",
          DateTime.now(),
          "Juan Pedro",
          "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fusers%2FuserImg.jpg?alt=media&token=9a12a294-94c9-4e76-8eae-86a17054bbe0"),
      Message(
          "",
          "me ha dejado sin palabras, quiero llorar",
          DateTime.now(),
          "Manito men",
          "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fusers%2FuserImg.jpg?alt=media&token=9a12a294-94c9-4e76-8eae-86a17054bbe0"),
    ];
  }
}

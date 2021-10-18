import 'package:eventy_front/objects/community.dart';
import 'package:intl/intl.dart';

import 'event.dart';

class User {
  int id;
  String profilePicture;
  String email;
  String password;
  List<String> preferences;
  String name;
  String biography;
  String birthday;
  //List<Event> events;
  //List<Community> communities;

  User(
    this.id,
    this.profilePicture,
    this.email,
    this.preferences,
    this.name,
    this.password,
    this.biography,
    this.birthday
    //this.events,
    //this.communities,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['profilePicture'],
      json['email'],
      (json['preferences'] as List).cast<String>(),
      json['name'],
      json['password'],
      json['biography'],
      json['birthday']
      //(json['events'] as List).cast<Event>(),
      //(json['communities'] as List).cast<Community>(),
    );
  }
}

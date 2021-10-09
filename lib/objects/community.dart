import 'package:eventy_front/objects/event.dart';

class Community {
  int id;
  String logo;
  String description;
  List<String> images;
  //List<Event> events;
  List<dynamic> members;
  String name;
  int creator;
  bool private;
  List<String> tags;

  Community(
      this.id,
      this.logo,
      this.description,
      this.images, //this.events,
      this.members,
      this.name,
      this.creator,
      this.private,
      this.tags);

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      json['id'],
      json['logo'],
      json['description'],
      (json['images'] as List).cast<String>(),
      //(json['events'] as List).cast<Event>(),
      json['members'],
      json['name'],
      json['creator'],
      json['private'],
      (json['tags'] as List).cast<String>(),
    );
  }
}

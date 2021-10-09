import 'package:eventy_front/objects/event.dart';

class Community {
  int id;
  String description;
  List<String> images;
  List<Event> events;
  int members;
  String name;
  int creator;
  bool private;
  List<String> tags;

  Community(this.id, this.description, this.images, this.events, this.members,
      this.name, this.creator, this.private, this.tags);

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      json['id'],
      json['description'],
      (json['images'] as List).cast<String>(),
      (json['events'] as List).cast<Event>(),
      json['members'],
      json['name'],
      json['creator'],
      json['private'],
      (json['tags'] as List).cast<String>(),
    );
  }
}

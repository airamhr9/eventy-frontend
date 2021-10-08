import 'package:eventy_front/objects/event.dart';

class Community {
  int id;
  String description;
  List<String> images;
  List<Event> events;
  int members;
  String name;
  int ownerId;
  bool private;
  String summary;
  List<String> tags;

  Community(this.id, this.description, this.images, this.events, this.members,
      this.name, this.ownerId, this.private, this.summary, this.tags);

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      json['id'],
      json['description'],
      (json['images'] as List).cast<String>(),
      (json['events'] as List).cast<Event>(),
      json['members'],
      json['name'],
      json['owner'],
      json['private'],
      json['summary'],
      (json['tags'] as List).cast<String>(),
    );
  }
}

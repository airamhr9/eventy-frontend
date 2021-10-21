class Community {
  int id;
  String logo;
  String description;
  List<String> images;
  List<String> members;
  String name;
  String creator;
  bool private;
  List<String> tags;
  //List<Event> events;

  Community(this.id, this.logo, this.description, this.images, this.members,
      this.name, this.creator, this.private, this.tags
      //this.events
      );

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      json['id'],
      json['logo'],
      json['description'],
      (json['images'] as List).cast<String>(),
      (json['members'] as List).cast<String>(),
      json['name'],
      json['creator'],
      json['private'],
      (json['tags'] as List).cast<String>(),
      //(json['events'] as List).cast<Event>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'logo': logo,
        'description': description,
        'images': images,
        'members': members,
        'name': name,
        'creator': creator,
        'private': private,
        'tags': tags
      };
}

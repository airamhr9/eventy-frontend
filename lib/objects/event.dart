class Eventy {
  int id;
  String description;
  String startDate; //Solo String temporalmente
  String finishDate; //Solo String temporalmente
  List<String> images;
  String location; //Solo String temporalmente
  int maxParticipants;
  String name;
  int ownerId;
  double price;
  bool private;
  String summary;
  List<String> tags;

  Eventy(
      this.id,
      this.description,
      this.startDate,
      this.finishDate,
      this.images,
      this.location,
      this.maxParticipants,
      this.name,
      this.ownerId,
      this.price,
      this.private,
      this.summary,
      this.tags);

  factory Eventy.fromJson(Map<String, dynamic> json) {
    return Eventy(
      json['id'],
      json['description'],
      json['startDate'],
      json['finishDate'],
      (json['images'] as List).cast<String>(),
      json['location'],
      json['maxParticipants'],
      json['name'],
      json['owner'],
      json['price'].toDouble(),
      json['private'],
      json['summary'],
      (json['tags'] as List).cast<String>(),
    );
  }
}

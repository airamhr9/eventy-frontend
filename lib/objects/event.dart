class Event {
  int id;
  String description;
  String startDate; //Solo String temporalmente
  String finishDate; //Solo String temporalmente
  List<String> images;
  double latitude; //Solo String temporalmente
  double longitude; //Solo String temporalmente
  int maxParticipants;
  List<int> participants;
  String name;
  int ownerId;
  double price;
  bool private;
  String summary;
  List<String> tags;

  Event(
      this.id,
      this.description,
      this.startDate,
      this.finishDate,
      this.images,
      this.latitude,
      this.longitude,
      this.maxParticipants,
      this.participants,
      this.name,
      this.ownerId,
      this.price,
      this.private,
      this.summary,
      this.tags);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      json['id'],
      json['description'],
      json['startDate'],
      json['finishDate'],
      (json['images'] as List).cast<String>(),
      json['latitude'],
      json['longitude'],
      json['maxParticipants'],
      (json['participants'] != null)
          ? (json['participants'] as List).cast<int>()
          : [],
      json['name'],
      json['owner'],
      json['price'].toDouble(),
      json['private'],
      json['summary'],
      (json['tags'] as List).cast<String>(),
    );
  }
}

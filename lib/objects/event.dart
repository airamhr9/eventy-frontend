class Event {
  int id;
  String description;
  String startDate;
  String finishDate;
  List<String> images;
  double latitude;
  double longitude;
  String address;
  int maxParticipants;
  List<String> participants;
  List<String> possiblyParticipants;
  String name;
  String ownerId;
  double price;
  bool private;
  List<String> tags;
  List<dynamic> scores;
  num averageScore;

  Event(
      this.id,
      this.description,
      this.startDate,
      this.finishDate,
      this.images,
      this.latitude,
      this.longitude,
      this.address,
      this.maxParticipants,
      this.participants,
      this.possiblyParticipants,
      this.name,
      this.ownerId,
      this.price,
      this.private,
      this.tags,
      this.scores,
      this.averageScore);

  factory Event.fromJson(Map<String, dynamic> json) {
    print("TYPE:" + json['scores'].runtimeType.toString());
    print("SCORES" + json['scores'].toString());
    return Event(
        json['id'],
        json['description'],
        json['startDate'],
        json['finishDate'],
        (json['images'] as List).cast<String>(),
        json['latitude'],
        json['longitude'],
        json['address'],
        json['maxParticipants'],
        (json['participants'] != null)
            ? (json['participants'] as List).cast<String>()
            : [],
        (json['possiblyParticipants'] != null)
            ? (json['possiblyParticipants'] as List).cast<String>()
            : [],
        json['name'],
        json['owner'],
        json['price'].toDouble(),
        json['private'],
        (json['tags'] as List).cast<String>(),
        (json['scores'] != null) ? json['scores'] as List<dynamic> : [],
        (json['averageScore'] != null)
            ? double.parse(json['averageScore'].toString())
            : -1);
  }

  Map toJson() {
    Map result = {
      'id': this.id,
      'description': this.description,
      'startDate': this.startDate,
      'finishDate': this.finishDate,
      'images': this.images,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'maxParticipants': this.maxParticipants,
      'participants': this.participants,
      'name': this.name,
      'owner': this.ownerId,
      'price': this.price,
      'private': this.private,
      'tags': this.tags,
      'scores': this.scores,
      'averageScore': this.averageScore
    };
    return result;
  }
}

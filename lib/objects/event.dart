class Event {
  int id;
  String description;
  String startDate; //Solo String temporalmente
  String finishDate; //Solo String temporalmente
  List<String> images;
  double latitude; //Solo String temporalmente
  double longitude; //Solo String temporalmente
  int maxParticipants;
  List<String> participants;
  String name;
  String ownerId;
  double price;
  bool private;
  String summary;
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
    this.maxParticipants,
    this.participants,
    this.name,
    this.ownerId,
    this.price,
    this.private,
    this.summary,
    this.tags,
    this.scores,
    this.averageScore,
  );

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
      json['maxParticipants'],
      (json['participants'] != null)
          ? (json['participants'] as List).cast<String>()
          : [],
      json['name'],
      json['owner'],
      json['price'].toDouble(),
      json['private'],
      json['summary'],
      (json['tags'] as List).cast<String>(),
      (json['scores'] != null) ? json['scores'] as List<dynamic> : [],
      (json['averageScore'] != null)
          ? double.parse(json['averageScore'].toString())
          : -1,
    );
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
      'maxParticipants': this.maxParticipants,
      'participants': this.participants,
      'name': this.name,
      'owner': this.ownerId,
      'price': this.price,
      'private': this.private,
      'summary': this.summary,
      'tags': this.tags,
      'scores': this.scores,
      'averageSocre': this.averageScore,
    };
    return result;
  }
}

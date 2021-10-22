class Message {
  String id;
  String text;
  DateTime dateTime;
  String userId;
  String image;
  Message(this.id, this.text, this.dateTime, this.userId, this.image);

  factory Message.fromJson(Map json) {
    return Message(json['id'], json['text'], DateTime.parse(json["time"]),
        json['user'], json['images']);
  }

  Map toJson() {
    return {
      'id': this.id,
      'text': this.text,
      'time': this.dateTime.toIso8601String(),
      'user': this.userId,
      'images': this.image
    };
  }
}

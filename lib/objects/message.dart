class Message {
  String id;
  String text;
  DateTime dateTime;
  String userId;
  String userName;
  String image;
  Message(this.id, this.text, this.dateTime, this.userId, this.userName,
      this.image);

  factory Message.fromJson(Map json) {
    return Message(
        json['id'].toString(),
        json['text'],
        DateTime.parse(json["time"]),
        json['userId'],
        json['username'],
        json['images']);
  }

  Map toJson() {
    return {
      'id': this.id,
      'text': this.text,
      'time': this.dateTime.toIso8601String(),
      'username': this.userName,
      'userId': this.userId,
      'images': this.image
    };
  }
}

class Message {
  int id;
  String text;
  DateTime dateTime;
  String userId;
  Message(this.id, this.text, this.dateTime, this.userId);

  factory Message.fromJson(Map json) {
    return Message(
        json['id'], json['text'], DateTime.parse(json["time"]), json['user']);
  }
}

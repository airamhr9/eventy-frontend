class Poll {
  int id;
  String name;
  List<String> options;
  String startDate;
  String finishDate;

  Poll(this.id, this.name, this.options, this.startDate, this.finishDate);

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      json['id'],
      json['name'],
      (json['options'] as List).cast<String>(),
      json['startDate'],
      json['finishDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'options': options,
        'startDate': startDate,
        'finishDate': finishDate
      };
}

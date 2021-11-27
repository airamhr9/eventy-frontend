class Survey {
  String id;
  String name;
  int numVotes;
  List<dynamic> options;
  String startDate;
  String finishDate;

  Survey(this.id, this.name, this.numVotes, this.options, this.startDate,
      this.finishDate);

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      json['id'],
      json['name'],
      json['numVotes'],
      (json['options'] as List).cast<dynamic>(),
      json['startDate'],
      json['finishDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'numVotes': numVotes,
        'options': options,
        'startDate': startDate,
        'finishDate': finishDate,
      };
}

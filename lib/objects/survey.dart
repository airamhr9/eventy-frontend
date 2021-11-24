class Survey {
  int id;
  String name;
  List<dynamic> options;
  String startDate;
  String finishDate;

  Survey(this.id, this.name, this.options, this.startDate, this.finishDate);

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      json['id'],
      json['name'],
      (json['options'] as List).cast<dynamic>(),
      json['startDate'],
      json['finishDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'options': options,
        'startDate': startDate,
        'finishDate': finishDate,
      };
}

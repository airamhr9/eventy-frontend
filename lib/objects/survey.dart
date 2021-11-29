class Survey {
  String id;
  String question;
  int numVotes;
  List<dynamic> options;
  bool userHasVoted;
  String startDate;
  String finishDate;

  Survey(this.id, this.question, this.numVotes, this.options, this.userHasVoted,
      this.startDate, this.finishDate);

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      json['id'],
      json['question'],
      json['numVotes'],
      (json['options'] as List).cast<dynamic>(),
      json['userHasVoted'],
      json['startDate'],
      json['finishDate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'numVotes': numVotes,
        'options': options,
        'userHasVoted': userHasVoted,
        'startDate': startDate,
        'finishDate': finishDate,
      };
}

class PostObject {
  String id;
  String title;
  String text;
  String date;
  String author;
  int numComments;
  List<String> images;

  PostObject(
    this.id,
    this.title,
    this.text,
    this.date,
    this.author,
    this.numComments,
    this.images,
  );

  factory PostObject.fromJson(Map<String, dynamic> json) {
    return PostObject(
      json['id'],
      json['title'],
      json['text'],
      json['date'],
      json['author'],
      json['numComments'],
      (json['images'] as List).cast<String>(),
    );
  }

  Map toJson() {
    Map result = {
      'id': this.id,
      'title': this.title,
      'text': this.text,
      'date': this.date,
      'author': this.author,
      'numComments': this.numComments,
      'images': this.images,
    };
    return result;
  }
}

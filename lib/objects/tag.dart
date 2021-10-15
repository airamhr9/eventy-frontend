class Tag {
  int id;
  String name;

  Tag(
    this.id,
    this.name)
  ;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json["id"]
      json["name"]
    );
  }
}
class Tag {
  String name;

  Tag(this.name);

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      json[""]
    );
  }
}

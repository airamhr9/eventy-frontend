class Memorie {
  String id;
  String description;
  String image;

  Memorie(this.id, this.description, this.image);

  factory Memorie.fromJson(Map<String, dynamic> json) {
    return Memorie(
      json['id'],
      json['question'],
      json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'image': image,
      };
}

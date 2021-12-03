class Memory {
  String description;
  String image;

  Memory(this.description, this.image);

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      json['text'],
      json['images'],
    );
  }

  Map<String, dynamic> toJson() => {
        'text': description,
        'images': image,
      };
}

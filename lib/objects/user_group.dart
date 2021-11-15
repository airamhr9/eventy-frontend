import 'package:eventy_front/objects/user.dart';

class UserGroup {
  String id;
  String username;
  String imageUrl;
  String dateMin;
  String dateMax;
  String price;
  List<String> tags;

  UserGroup(this.id, this.username, this.imageUrl, this.dateMin, this.dateMax,
      this.price, this.tags);

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      json['id'],
      json['username'],
      json['image'],
      json['dateMin'],
      json['dateMax'],
      json['price'],
      (json['tags'] as List).cast<String>(),
    );
  }
}

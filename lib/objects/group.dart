import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/objects/user_group.dart';

class Group {
  String id;
  String creator;
  List<UserGroup> users;
  Group(this.id, this.creator, this.users);

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(json["id"], json["creator"],
        (json["users"] as List).map((e) => UserGroup.fromJson(e)).toList());
  }

  @override
  String toString() {
    return "Group $id";
  }
}

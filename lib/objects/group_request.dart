import 'package:eventy_front/objects/user.dart';

class GroupRequest {
  final User user;
  final String groupId;

  const GroupRequest(this.user, this.groupId);

  factory GroupRequest.fromJson(Map<String, dynamic> json) {
    return GroupRequest(User.fromJson(json["groupCreator"]), json["group"]);
  }

  @override
  String toString() {
    return "Request from $groupId";
  }
}

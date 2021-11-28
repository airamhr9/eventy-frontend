import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/group_request.dart';
import 'package:eventy_front/services/group_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Se crea un grupo y se envía la invitación', () async {
    GroupService groupService = GroupService();
    String user1 = "8qQpJyOmcCRAh9pZ4yFvntVu4oq2";
    String user2 = "Xamie8BQKCdD6mup0ew5KlQFBiI2";

    String newGroupId = await groupService.createGroup(user1, [user2]);

    List<Group> user1Groups = await groupService.getGroups(user1);
    List<GroupRequest> user2Requests = await groupService.getRequests(user2);

    bool groupExists =
        user1Groups.map((e) => e.id).toList().contains(newGroupId);
    bool invitationSent =
        user2Requests.map((e) => e.groupId).toList().contains(newGroupId);

    expect(groupExists, true);
    expect(invitationSent, true);
  });
}

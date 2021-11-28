import 'package:eventy_front/objects/group.dart';
import 'package:eventy_front/objects/group_request.dart';
import 'package:eventy_front/services/group_service.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Users should be able to accept invitations to join their groups', () async {
    GroupService groupService = GroupService();
    String user1 = "8qQpJyOmcCRAh9pZ4yFvntVu4oq2";
    String user2 = "Xamie8BQKCdD6mup0ew5KlQFBiI2";


    String newGroupId = await GroupService().createGroup(user1, [user2]);
    debugPrint(newGroupId);


    //List<GroupRequest> userRequests = await groupService.getRequests(user2);
    Map<String, dynamic> filters = {};
    filters["userId"] = user2;
    filters["validPreferences"] = false;
    bool accepted = await groupService.updateUser(newGroupId, filters, userId: user2);



    List<Group> userGroups = await groupService.getGroups(user2);

    bool joinedGroup =
    userGroups.map((e) => e.id).toList().contains(newGroupId);
    expect(accepted, true);
    expect(joinedGroup, true);

  });
}

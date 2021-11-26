import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String senderID = '8rKa5lPLoYVD3UsQif3nqYV0cJ73';
  String senderUsername = 'airamhr';
  String reveiverID = 'Dfsx7DZ8LoQMZQM1OqNbt8iUcrH3';
  String receiverUsername = 'diego';

  UserService userService = UserService();

  test('Enviar petición de amistad', () async {
    userService.handleFriendRequest(senderID, receiverUsername, 'REQUEST');
    await Future.delayed(Duration(seconds: 2));

    List<List<User>> friendsAndRequests = await userService.getFriends(reveiverID);
    List<User> requests = friendsAndRequests[1];

    bool requestExists = requests.map((user) => user.userName).toList().contains(senderUsername);
    expect(requestExists, true);
  });

  test('Aceptar petición de amistad', () async {
    userService.handleFriendRequest(reveiverID, senderUsername, 'ACCEPT');
    await Future.delayed(Duration(seconds: 2));

    List<List<User>> senderFriendsAndRequests = await userService.getFriends(senderID);
    List<User> senderFriends = senderFriendsAndRequests[0];
    List<List<User>> receiverFriendsAndRequests = await userService.getFriends(reveiverID);
    List<User> receiverFriends = receiverFriendsAndRequests[0];
    List<User> receiverRequests = receiverFriendsAndRequests[1];

    bool friendExistsInSender = senderFriends.map((user) => user.userName).toList().contains(receiverUsername);
    bool friendExistsInReceiver = receiverFriends.map((user) => user.userName).toList().contains(senderUsername);
    bool requestDeleted = !(receiverRequests.map((user) => user.userName).toList().contains(senderUsername));
    expect(friendExistsInSender, true);
    expect(friendExistsInReceiver, true);
    expect(requestDeleted, true);
  });
}
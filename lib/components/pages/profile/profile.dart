import 'package:eventy_front/components/pages/friends/friends.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:eventy_front/services/tags_service.dart';

class Profile extends StatefulWidget {
  const Profile() : super();

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<String> tags = [];

  String userId = "";
  User user = User(
      "-1",
      "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fusers%2FuserImg.jpg?alt=media&token=9a12a294-94c9-4e76-8eae-86a17054bbe0",
      "",
      [],
      "CARGANDO",
      "",
      "",
      "",
      "userImage.jpg");

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance.getStringValue("userId").then((value) {
      setState(() {
        userId = value;
      });

      print("id" + userId);
      UserService().getUser(userId).then((value) => setState(() {
            user = value;
          }));

      UserService().getUserPreferences(userId, "").then((value) => setState(() {
            print("Here " + userId);
            tags = value;
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return (SingleChildScrollView(child: buildProfile()));
  }

  Container buildProfile() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture),
              radius: 80,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              user.userName,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                user.bio,
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),

            /* TextButton.icon(onPressed:
              (){}, icon:  Icon(
                  Icons.edit_rounded
              ), label: Text(
                  "Editar"
                  
              )),*/
          ]),
          SizedBox(
            height: 10,
          ),
          Text(
            "Mis preferencias",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              child: Wrap(
            spacing: 5,
            runSpacing: 3,
            children: [
              ...tags.map((tag) => FilterChip(
                    label: Text(tag),
                    onSelected: (bool selected) {},
                  ))
            ],
          )),
          TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Friends(userId)));
              },
              icon: Icon(Icons.people_rounded),
              label: Text("Mis amigos"))
          /*Wrap(
          children: List<Widget>.generate(
            options.length,
                (int idx) {
              return ChoiceChip(
                  label: Text(options[idx]),
                  selected: _value == idx,
                  onSelected: (bool selected) {
                    setState(() {
                      _value = selected ? idx : null;
                    });
                  });
            },
          ).toList(),
        );*/
        ]));
  }
}

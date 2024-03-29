import 'dart:io';

import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventy_front/services/tags_service.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit() : super();

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  ImagePicker picker = ImagePicker();
  ImageProvider _img = NetworkImage("");
  File _imgFile = File("");
  String userId = "";
  User user = User(
      "-1",
      "https://firebasestorage.googleapis.com/v0/b/eventy-a8e4c.appspot.com/o/images%2Fusers%2FuserImg.jpg?alt=media&token=9a12a294-94c9-4e76-8eae-86a17054bbe0",
      "A",
      [],
      "TEST",
      "000",
      "A",
      "0",
      "userImage.jpg");

  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final TextEditingController _userName = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    MySharedPreferences.instance.getStringValue("userId").then((value) {
      setState(() {
        userId = value;
      });
      print("id" + userId);
      _fetchData();
    });
  }

  List<String> tags = [];
  List<String> selectedTags = [];

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _imgFile = File(image!.path);
      print(_imgFile.path);
      _img = FileImage(_imgFile);
      print(_imgFile.path.split('/').last);
    });
  }

  _fetchData() async {
    UserService().getUser(userId).then((value) => setState(() {
          user = value;
          _img = NetworkImage(user.profilePicture);
          _bio.text = user.bio;
          _imgFile =
              File((user.profilePicture.split('%2F').last).split('?').first);
        }));

    UserService().getUserPreferences(userId, "").then((value) => setState(() {
          print("Here " + userId);
          selectedTags = value;
        }));
    TagsService().get().then((value) => setState(() {
          tags = value;
        }));
  }

  void updateUser(BuildContext context) async {
    //if (_formKey.currentState!.validate() ) {

    print("Id: " + userId);

    final User finalUser = User(
        userId,
        _imgFile.path.split('/').last,
        user.email,
        selectedTags,
        user.userName,
        user.password,
        _bio.text,
        user.birthdate,
        _imgFile.path.split('/').last);
    // print("user creado" + finalUser.toString());
    UserService().updateUser(finalUser);
    UserService().sendImage(FileImage(_imgFile));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blueAccent,
        content: Text("Datos actualizados correctamente")));

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar perfil"),
          automaticallyImplyLeading: true,
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 1)),
          ),
          child: (SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: Colors.white),
                child: Form(
                    child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          _imgFromGallery();
                        }, // handle your image tap here
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(12),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundImage: _img,
                                radius: 80,
                              ),
                            ),
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 35,
                              color: Colors.black,
                            )
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    /*TextFormField(
                    minLines: 1,
                    controller: _userName,

                    validator: (value) {
                      return (value!.isEmpty)
                          ? 'El nombre de usuario no puede estar vacio'
                          : null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintText: "Nombre de Usuario"),
                  ),*/
                    Text(user.userName,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      minLines: 1,
                      controller: _bio,
                      validator: (value) {
                        return (value!.isEmpty)
                            ? 'Introduce una biografía'
                            : null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          filled: true,
                          hintText: "Biografía"),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(indent: 16),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Editar preferencias",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Wrap(spacing: 5, runSpacing: 3, children: [
                        ...tags.map((tag) {
                          bool selected = selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: selected,
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.transparent,
                            labelStyle: (selected)
                                ? TextStyle(color: Colors.white)
                                : TextStyle(),
                            checkmarkColor:
                                (selected) ? Colors.white : Colors.black,
                            selectedColor: Colors.black,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedTags.add(tag);
                                } else {
                                  selectedTags.remove(tag);
                                }
                              });
                            },
                          );
                        })
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            // double.infinity is the width and 30 is the height
                            primary: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          buildMessageUpdateUser();
                        },
                        child: Text("Guardar cambios"))
                  ],
                ))),
          )),
        ));
  }

  bool validateFields(BuildContext context) {
    return true;
  }

  void buildMessageUpdateUser() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Actualizar datos de usuario",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black87),
            ),
            content: Text("¿Desea guardar los datos introducidos?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.black54),
                  )),
              TextButton(
                  onPressed: () {
                    updateUser(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Actualizar",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
}

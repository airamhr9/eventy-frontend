import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit() : super();

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late File _image;
  final TextEditingController _userName = TextEditingController();

  _imgFromGallery() async {
    ImagePicker picker = ImagePicker();
    PickedFile? image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image as File;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar Perfil"),
          automaticallyImplyLeading: true,
        ),
        body: (SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(color: Colors.white),
              child: Form(
                  child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        _imgFromGallery();
                        //Completar con qué hacer con la foto
                      }, // handle your image tap here
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: const Color(0xff7c94b6),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'hhttps://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.lightBlue,
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(12),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                              radius: 80,
                            ),

                          ),

                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 35,
                            color: Colors.blue,
                          )
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    minLines: 1,
                    controller: _userName,
                    validator: (value) {
                      return (value!.isEmpty)
                          ? 'Debes tener un nombre de usuario'
                          : null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintText: "Nombre de Usuario"),
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
                    style: TextStyle(
                        color: Colors.black54),
                  ),
                  /* */
                ],
              ))),
        )));
  }
}

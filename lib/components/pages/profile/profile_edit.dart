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
   ImageProvider _img = NetworkImage(
       'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png');

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final TextEditingController _userName = TextEditingController();
   final TextEditingController _bio = TextEditingController();


   List<String> tags = [];
   List<String> tagsCommunity = [];

  _imgFromGallery() async {

    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _img = FileImage(File(image!.path));
    });
  }
@override
void initState() {

    super.initState();
    TagsService().get().then((value) => setState(() {
      print("Here");
      tags = value;
    }));
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
                                    ''),
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
                              backgroundImage: _img
                              ,
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
                    style: TextStyle(
                        color: Colors.black54),
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
                            selected: tagsCommunity.contains(tag),
                            selectedColor: Colors.lightBlue[100],
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  tagsCommunity.add(tag);
                                } else {
                                  tagsCommunity.remove(tag);
                                }
                              });
                            },
                          ))
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          // double.infinity is the width and 30 is the height
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        updateUser(context);
                      },
                      icon: Icon(Icons.save_rounded),
                      label: Text("Guardar cambios"))

                ],
              ))),
        )));
  }

  bool validateFields(BuildContext context){
    return true;
  }

/*Future<User> getUser()async{

    return user;
}*/


  void updateUser(BuildContext context) async{
    if(_formKey.currentState!.validate() && validateFields(context)){
      String userId = await MySharedPreferences.instance.getStringValue("userId");
      print("Id: " + userId);
      User user = UserService().getUser(userId) as User;

      final User finalUser = User(
       userId,
        user.profilePicture,
        user.email,
        user.preferences,
        user.userName,
        user.password,
        user.bio,
        user.birthdate);

      print("user obtenido " + user.toString());
      print("user creado" + finalUser.toString());


    }
  }

}

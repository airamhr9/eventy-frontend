import 'dart:io';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/objects/user.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/muro_service.dart';
import 'package:eventy_front/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewPost extends StatefulWidget {
  final int cId;
  const AddNewPost(this.cId) : super();

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _postNameController = TextEditingController();
  final TextEditingController _postDescriptionController =
      TextEditingController();
  String date = DateTime.now().toIso8601String();
  ImagePicker picker = ImagePicker();
  ImageProvider imageProviders = NetworkImage("");
  File imageFiles = File("");

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Publicación"),
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 1)),
        backgroundColor: Colors.white,
      ),
      body: (SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(color: Colors.white),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        //Nombre de la comunidad
                        controller: _postNameController,
                        validator: (value) {
                          return (value!.isEmpty)
                              ? 'La publicación debe tener un título'
                              : null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            filled: false,
                            hintText: "Título de la publicación"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        minLines: 8,
                        maxLines: 20,
                        controller: _postDescriptionController,
                        validator: (value) {
                          return (value!.isEmpty)
                              ? 'La publicación debe tener descripcion'
                              : null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            filled: false,
                            hintText: "Descripcion"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            _imgFromGallery();
                          }, // handle your image tap here
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                    style: BorderStyle.solid)),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProviders,
                                      fit: BoxFit.fitWidth)),
                              child: Center(
                                  child: Icon(Icons.photo_camera_rounded,
                                      color: Theme.of(context).primaryColor)),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              primary: Colors.black,
                              // double.infinity is the width and 30 is the height
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            sendPost();
                          },
                          child: Text("Publicar")),
                    ],
                  ))))),
    );
  }

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String path = "";
    if (image != null) {
      path = image.path;
      setState(() {
        imageProviders = FileImage(File(path));
        imageFiles = File(path);
      });
    }
  }

  sendPost() async {
    PostObject sendingPost = PostObject(
        widget.cId.toString(),
        _postNameController.text,
        _postDescriptionController.text,
        date,
        user.userName,
        0,
        0,
        0,
        imageFiles.path.split('/').last);
    print(sendingPost.toJson());
    MuroService().newPost(sendingPost, widget.cId.toString());
    MuroService().sendImage(FileImage(imageFiles));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Tu post ha sido creado correctamente",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black87),
            ),
            content: Text("Se te devolverá a la ventana de tu comunidad"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Vale",
                    style: TextStyle(color: Colors.lightBlue),
                  ))
            ],
          );
        });
  }
}

import 'dart:io';
import 'package:eventy_front/objects/post.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/muro_service.dart';
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

  final TextEditingController _postNameController =
  TextEditingController();
  final TextEditingController _postDescriptionController =
  TextEditingController();
  String date = DateTime.now().toIso8601String();
  ImagePicker picker = ImagePicker();
  ImageProvider imageProviders = NetworkImage("");
  File imageFiles = File("");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Publicación"),
        automaticallyImplyLeading: true,
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
                                borderSide: BorderSide.none),
                            filled: true,
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
                                borderSide: BorderSide.none),
                            filled: true,
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
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              // double.infinity is the width and 30 is the height
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                          sendPost();

                          },
                          icon: Icon(Icons.add_circle_rounded),
                          label: Text("Publicar")),
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
         await MySharedPreferences.instance.getStringValue("userName"),
         0, 0, 0, imageFiles.path.split('/').last);
      MuroService().newPost(sendingPost);

  }
}
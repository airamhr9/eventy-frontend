import 'dart:io';
import 'package:eventy_front/components/pages/communities/community_view.dart';
import 'package:eventy_front/components/pages/my_events/add_event.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/services/communities_service.dart';
import 'package:eventy_front/services/tags_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class AddCommunity extends StatefulWidget {
  const AddCommunity() : super();

  @override
  _AddCommunityState createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  late Community community;

  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _descriptionCommunityController =
      TextEditingController();
  String _visibilityValue = "Público";

  List<String> tags = [];
  List<String> tagsCommunity = [];

  ImageProvider _img = NetworkImage('');
  ImageProvider _imgLogo = NetworkImage('');
  ImagePicker picker = ImagePicker();
  FileImage? imageToSend;
  FileImage? imageLogoToSend;

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _img = FileImage(File(image!.path));
      imageToSend = FileImage(File(image.path));
    });
  }

  _imgLogoFromGallery() async {
    XFile? imageLogo =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _imgLogo = FileImage(File(imageLogo!.path));
      imageLogoToSend = FileImage(File(imageLogo.path));
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
        title: Text("Crear comunidad"),
        automaticallyImplyLeading: true,
      ),
      body: (SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(color: Colors.white),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Imágenes",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        _imgFromGallery();
                      }, // handle your image tap here
                      child: Card(
                        //Imágenes de la página principal de la comunidad
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                                style: BorderStyle.solid)),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(image: _img)),
                          height: 150,
                          child: Center(
                              child: Icon(Icons.photo_camera_rounded,
                                  color: Theme.of(context).primaryColor)),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    //Nombre de la comunidad
                    controller: _communityNameController,
                    validator: (value) {
                      return (value!.isEmpty)
                          ? 'La comunidad debe tener nombre'
                          : null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintText: "Nombre"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Logo",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        _imgLogoFromGallery();
                      }, // handle your image tap here
                      child: Card(
                        //Logo
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                                style: BorderStyle.solid)),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: _img),
                          ),
                          height: 100,
                          width: 100,
                          child: Center(
                              child: Icon(Icons.photo_camera_rounded,
                                  color: Theme.of(context).primaryColor)),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    minLines: 8,
                    maxLines: 20,
                    controller: _descriptionCommunityController,
                    validator: (value) {
                      return (value!.isEmpty)
                          ? 'La comunidad debe tener descripcion'
                          : null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        filled: true,
                        hintText: "Descripcion"),
                  ),
                  /*SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Añadir Evento",
                    style: TextStyle(color: Colors.black54),
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity,
                              40), // double.infinity is the width and 40 is the height
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEvent()));
                      },
                      icon: Icon(Icons.add_circle_rounded),
                      label: Text("")),*/
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Etiquetas",
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
                  buildVisibilityRadioGroup(context),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity,
                              50), // double.infinity is the width and 30 is the height
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        buildCommunity();
                        CommunityService().post(community);
                        showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text(
                                  "Comunidad creada con éxito",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.black87),
                                ),
                                content: Text(
                                    "Ahora se le mostrará la pantalla principal de su comunidad."),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text("Vale"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommunityView(
                                                      this.community)));
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.add),
                      label: Text("Crear comunidad")),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ))))),
    );
  }

  Widget buildVisibilityRadioGroup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tipo de comunidad",
          style: TextStyle(color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            RadioButton(
              description: "Pública",
              value: "Público",
              groupValue: _visibilityValue,
              onChanged: (value) {
                setState(() {
                  _visibilityValue = value as String;
                });
              },
            ),
            RadioButton(
                description: "Privada",
                value: "Privado",
                groupValue: _visibilityValue,
                onChanged: (value) {
                  setState(() {
                    _visibilityValue = value as String;
                  });
                })
          ],
        )
      ],
    );
  }

  buildCommunity() {
    bool isPrivate = false;
    if (_visibilityValue == "Público") {
      isPrivate = false;
    } else {
      isPrivate = true;
    }
    String logo = _imgLogo.toString();
    String im = _img.toString();
    community = Community(
        -1,
        logo
            .substring(logo.lastIndexOf("/") + 1),
        _descriptionCommunityController.text,
        [im.substring(im.lastIndexOf("/") + 1)],
        [2],
        _communityNameController.text,
        2,
        isPrivate,
        tagsCommunity);

    if (imageToSend != null) {
      CommunityService().sendImage(imageToSend!).then((value) {
        String result = value ? "Envío correcto" : "Fallo en el envío";
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      });
    }
    if (imageLogoToSend != null) {
      CommunityService().sendImage(imageLogoToSend!).then((value) {
        String result = value ? "Envío correcto" : "Fallo en el envío";
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      });
    }
  }
}

import 'dart:io';
import 'package:eventy_front/components/pages/communities/create_community.dart';
//import 'package:eventy_front/components/pages/my_events/add_event.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/persistence/my_shared_preferences.dart';
import 'package:eventy_front/services/tags_service.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddCommunity extends StatefulWidget {
  const AddCommunity() : super();

  @override
  _AddCommunityState createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  late Community community;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _descriptionCommunityController =
      TextEditingController();
  String _visibilityValue = "Público";

  List<String> tags = [];
  List<String> tagsCommunity = [];

  ImageProvider imageLogo = NetworkImage('');
  List<ImageProvider> imageProviders = [];
  List<FileImage> imageFiles = [];
  ImagePicker picker = ImagePicker();
  FileImage? imageLogoToSend;

  _imgFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String path = "";
    if (image != null) {
      path = image.path;
      setState(() {
        imageProviders.add(FileImage(File(path)));
        imageFiles.add(FileImage(File(path)));
      });
    }
  }

  _imgLogoFromGallery() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    String path = "";
    if (image != null) {
      path = image.path;
      setState(() {
        imageLogo = FileImage(File(path));
        imageLogoToSend = FileImage(File(path));
      });
    }
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
                  key: _formKey,
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
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                    style: BorderStyle.solid)),
                            child: Container(
                              height: 100,
                              child: Center(
                                  child: Icon(Icons.photo_camera_rounded,
                                      color: Theme.of(context).primaryColor)),
                            ),
                          )),
                      Container(
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 3,
                          children: [
                            ...imageProviders.map((e) => Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                            height: 65,
                                            width: 105,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: e,
                                                    fit: BoxFit.fitWidth)))),
                                    SizedBox(
                                      height: 30,
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              imageProviders.remove(e);
                                              imageFiles.remove(e);
                                            });
                                          },
                                          child: Text(
                                            "Eliminar",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
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
                                image: DecorationImage(image: imageLogo),
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
                            createCommunity(context);
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

  bool validateFields(BuildContext context) {
    if (imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Debes seleccionar al menos una imagen")));
      return false;
    }
    if (imageLogoToSend == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("La comunidad debe tener un logo.")));
      return false;
    }
    return true;
  }

  createCommunity(BuildContext context) async {
    String userId = await MySharedPreferences.instance.getStringValue("userId");
    if (_formKey.currentState!.validate() && validateFields(context)) {
      if (tagsCommunity.isEmpty) {
        tagsCommunity.add("");
      }
      String logo = basename(imageLogoToSend!.file.path);
      community = Community(
          -1,
          logo,
          _descriptionCommunityController.text,
          imageFiles.map((e) => basename(e.file.path)).toList(),
          [userId],
          _communityNameController.text,
          userId,
          (_visibilityValue == "Público") ? false : true,
          tagsCommunity);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CreateCommunity(community, imageFiles, imageLogoToSend!);
      }));
    }
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
}

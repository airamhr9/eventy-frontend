import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AddCommunity extends StatefulWidget {
  const AddCommunity() : super();

  @override
  _AddCommunityState createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _descriptionCommunityController =
      TextEditingController();

  //final TextEditingController _membersController = TextEditingController();
  String _visibilityValue = "Público";
  //bool hasMaxMembers = false;

  @override
  Widget build(BuildContext context) {
    return (SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(color: Colors.white),
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  //Imágenes de la página principal de la comunidad
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
                Card(
                  //Logo
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
                ),
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
                    onPressed: () {},
                    icon: Icon(Icons.add_rounded),
                    label: Text("Publicar evento"))
              ],
            )))));
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
                }),
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

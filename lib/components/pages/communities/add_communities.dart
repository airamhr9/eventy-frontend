import 'package:eventy_front/components/pages/communities/community_view.dart';
import 'package:eventy_front/components/pages/my_events/add_event.dart';
import 'package:eventy_front/objects/community.dart';
import 'package:eventy_front/services/tags_service.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AddCommunity extends StatefulWidget {
  const AddCommunity() : super();

  @override
  _AddCommunityState createState() => _AddCommunityState();
}

class _AddCommunityState extends State<AddCommunity> {
  late Community community;
  List<dynamic> tags = [];
  List<String> tagsCommunity = [];

  @override
  void initState() {
    super.initState();
    TagsService().get().then((value) => setState(() {
          print("Here");
          tags = value;
        }));
  }

  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _descriptionCommunityController =
      TextEditingController();

  String _visibilityValue = "Público";

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
                      height: 150,
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
                  Text(
                    "Logo",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 5,
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
                      width: 100,
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
                      label: Text("")),
                  /**************/
                  //ListView.builder(itemBuilder: itemBuilder),
                  /**************/
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
                      ...tags.map(buildTagFilterChip).toList()
                    ],
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  buildVisibilityRadioGroup(context),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity,
                              50), // double.infinity is the width and 30 is the height
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        community.images = [];
                        community.logo = "";
                        community.name = _communityNameController.toString();
                        community.description =
                            _descriptionCommunityController.toString();
                        if (_visibilityValue == "Público") {
                          community.private = false;
                        } else {
                          community.private = true;
                        }
                        community.tags = tagsCommunity;
                        community.members = [];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommunityView(this.community)));
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

  Widget buildTagFilterChip(tag) => FilterChip(
        label: Text(tag.name),
        selected: tagsCommunity.contains(tag.name),
        selectedColor: Colors.blueAccent,
        onSelected: (bool selected) {
          setState(() {
            if (!selected) {
              tagsCommunity.add(tag.name.toString());
              print("\n" + tagsCommunity.toString());
            } else {
              tagsCommunity.remove(tag.name);
              print("\n" + tagsCommunity.toString());
            }
          });
        },
      );
}
